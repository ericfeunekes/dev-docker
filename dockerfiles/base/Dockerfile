ARG VERSION 3.10
FROM python:$VERSION

RUN apt -y upgrade && apt - update
RUN apt -y install neovim
COPY ./dockerfiles/base/base-init.vim /root/.config/nvim/init.vim

RUN curl -sSLk https://install.python-poetry.org | python3 - 
ENV PATH="/root/.local/bin:${PATH}"
RUN poetry --version

CMD /bin/bash
