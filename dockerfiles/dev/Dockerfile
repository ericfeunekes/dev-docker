ARG VERSION 3.10
FROM python:$VERSION-bullseye

COPY ./dockerfiles/dev/dev-install.sh /tmp/
RUN /bin/bash /tmp/dev-install.sh

COPY ./dockerfiles/dev/init.vim /root/.config/nvim/
RUN sh -c 'curl -k -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' \

RUN curl -sSLk https://install.python-poetry.org | python3 - 
ENV PATH="/root/.local/bin:${PATH}"
#RUN poetry --version

CMD /bin/bash
