FROM openjdk:8

# Configuration variables.
ENV JIRA_HOME     /var/atlassian/jira
ENV JIRA_INSTALL  /opt/atlassian/jira
ENV JIRA_VERSION  7.0.0

# Install Atlassian JIRA and helper tools and setup initial home
# directory structure.
RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends libtcnative-1 xmlstarlet \
    && apt-get clean \
    && mkdir -p                "${JIRA_HOME}" \
    && mkdir -p                "${JIRA_HOME}/caches/indexes" \
    && chmod -R 700            "${JIRA_HOME}" \
    && chown -R daemon:daemon  "${JIRA_HOME}" \
    && mkdir -p                "${JIRA_INSTALL}/conf/Catalina" \
    && curl -Ls                "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}-jira-${JIRA_VERSION}.tar.gz" | tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner \
    && curl -Ls                "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz" | tar -xz --directory "${JIRA_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar" \
    && chmod -R 700            "${JIRA_INSTALL}/conf" \
    && chmod -R 700            "${JIRA_INSTALL}/logs" \
    && chmod -R 700            "${JIRA_INSTALL}/temp" \
    && chmod -R 700            "${JIRA_INSTALL}/work" \
    && chown -R daemon:daemon  "${JIRA_INSTALL}/conf" \
    && chown -R daemon:daemon  "${JIRA_INSTALL}/logs" \
    && chown -R daemon:daemon  "${JIRA_INSTALL}/temp" \
    && chown -R daemon:daemon  "${JIRA_INSTALL}/work" \
    && sed --in-place          "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
    && echo -e                 "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties" \
    && touch -d "@0"           "${JIRA_INSTALL}/conf/server.xml"

RUN rm -f                            ${JIRA_INSTALL}/lib/postgresql-9*.jdbc4.jar \
    && wget -q -P                       "${JIRA_INSTALL}/lib" "https://jdbc.postgresql.org/download/postgresql-9.4.1212.jre6.jar" \
    && rm -f                            ${JIRA_HOME}/plugins/installed-plugins/*atlassian-universal-plugin-manager-plugin*.jar \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/23915/version/3000150" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*drawio*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/1211413/version/600200200" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/emaileditor-jira-plugin*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/1211404/version/100520" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/jira-calendar-plugin*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/293/version/400000300" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/jira-charting-plugin*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/288/version/2340" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/jira-importers-plugin*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/32645/version/368" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/jira-misc-custom-fields*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/27136/version/100700200" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*jira-suite-utilities*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/5048/version/360" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*jira-toolkit*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/5142/version/224" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*jira-watcher-field*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/6306/version/256" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*mailrucal*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/1211040/version/760" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*rest-api-browser*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/1211542/version/30220" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*scriptrunner-jira*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/6820/version/1001340" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*solveka-jira-drag-drop-files*.jar" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*stp-*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/37243/version/3010022" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*uniqueregexfield*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/1211043/version/80" \
    && rm -f                            "${JIRA_HOME}/plugins/installed-plugins/*workflowenhancer*.jar" \
    && wget -q --content-disposition -P "${JIRA_HOME}/plugins/installed-plugins" "https://marketplace.atlassian.com/download/apps/575829/version/1021" \
    && chmod -R 700            "${JIRA_HOME}/plugins" \
    && chown -R daemon:daemon  "${JIRA_HOME}/plugins"
    && add                      dbconfig.xml ${JIRA_HOME}
    && chown -R daemon:daemon  "${JIRA_HOME}/dbconfig.xml

# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
USER daemon:daemon

# Expose default HTTP connector port.
EXPOSE 8080

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/atlassian/jira", "/opt/atlassian/jira/logs"]

# Set the default working directory as the installation directory.
WORKDIR /var/atlassian/jira

COPY "docker-entrypoint.sh" "/"
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run Atlassian JIRA as a foreground process by default.
CMD ["/opt/atlassian/jira/bin/catalina.sh", "run"]
