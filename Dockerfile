FROM ruby:3.1.0
WORKDIR /pokemon
COPY Gemfile /pokemon/Gemfile
COPY Gemfile.lock /pokemon/Gemfile.lock
RUN bundle install

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
