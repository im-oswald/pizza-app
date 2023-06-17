# syntax=docker/dockerfile:1
FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /pizza-app
COPY Gemfile /pizza-app/Gemfile
COPY Gemfile.lock /pizza-app/Gemfile.lock
RUN bundle install

COPY . /pizza-app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Install forego
RUN curl -o /usr/local/bin/forego https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64
RUN chmod +x /usr/local/bin/forego
EXPOSE 3000

CMD forego start -f Procfile
