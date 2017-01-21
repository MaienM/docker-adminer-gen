FROM ruby

# Install dependencies
WORKDIR /app
ADD Gemfile* /app/
RUN bundle install --without development

# Add source
ADD app/* /app/

# Add the plugin
ADD data/plugin.php /data/plugin.php

# The volume where the plugin and it's data are stored
VOLUME /data

CMD ["/bin/sh", "/app/start.sh"]
