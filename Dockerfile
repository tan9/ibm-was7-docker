######################
# INSTALLATION STAGE #
######################
FROM ubuntu:16.04 as builder

ARG USER=was
ARG GROUP=was

COPY source /work/source
COPY update /work/update
COPY responsefile /work/responsefile

RUN groupadd $GROUP \
  && useradd $USER -g $GROUP -m \
  && chown -R $USER:$GROUP /work /opt

USER $USER

RUN echo "📦 Unarchiving WebSphere Application Server 7.0 intallation package..." \
  && mkdir -p /work/was \
  && tar -xzf /work/source/was.7000.wasdev.nocharge.linux.amd64.tar.gz -C /work/was/ \
  && echo "☑ Done."

RUN echo "📥 Installing WebSphere Application Server 7.0..." \
  && /work/was/WAS/install -options /work/responsefile/responsefile.text -silent \
  && echo "☑ Done."

RUN echo "📦 Unarchiving WebSphere Application Server 7.0 Update Installer intallation package..." \
  && mkdir -p /work/updi \
  && tar -xzf /work/source/7.0.0.*-WS-UPDI-LinuxAMD64.tar.gz -C /work/updi/ \
  && echo "☑ Done."

RUN echo "📥 Installing WebSphere Application Server 7.0 Update Installer..." \
  && /work/updi/UpdateInstaller/install -options /work/responsefile/responsefile.updateinstaller.text -silent \
  && echo "☑ Done."

RUN echo "📥 Installing WebSphere Application Server 7.0 Updates..." \
  && /opt/IBM/WebSphere/UpdateInstaller/update.sh -options /work/responsefile/responsefile.update.text -silent \
  && echo "☑ Done."


##########################
# PROFILE CREATION STAGE #
##########################
FROM ubuntu:16.04

LABEL maintainer="Pei-Tang Huang <beta@cht.com.tw>"

ARG USER=was
ARG GROUP=was

COPY --from=builder /opt /opt

# !!! IMPORTANT !!!
# change default Ubuntu's default shell interpreter from dash to bash
# or the wsadmin.sh will not run properly
RUN yes n | dpkg-reconfigure dash > /dev/null 2>&1

RUN groupadd $GROUP \
  && useradd $USER -g $GROUP -m \
  && chown -R $USER:$GROUP /opt

USER $USER

# mark createProfileShortCut2StartMenuDefault optional
RUN sed -i 's#<action path="actions/createProfileShortCut2StartMenuDefault.ant" priority="93" isFatal="false">#<action path="actions/createProfileShortCut2StartMenuDefault.ant" priority="93" isFatal="false" isOptional="true">#' \
  /opt/IBM/WebSphere/AppServer/profileTemplates/default/actionRegistry.xml

# create profile
RUN /opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh \
  -create \
  -isDefault \
  -isDeveloperServer \
  -omitAction createProfileShortCut2StartMenuDefault

ENV PATH /opt/IBM/WebSphere/AppServer/bin:$PATH

EXPOSE 9060 9080

CMD /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/startServer.sh server1 \
  && tail --retry -f /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/logs/server1/SystemOut.log
