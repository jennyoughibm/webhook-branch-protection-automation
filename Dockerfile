FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y build-essential

ENV PROJECT_PATH /data/apps/branchprotection
RUN mkdir -p $PROJECT_PATH

WORKDIR /data/apps/branchprotection

ADD branchprotection ./

EXPOSE 3000

COPY script/entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
