FROM nginxinc/nginx-unprivileged:1.27-alpine as final

ARG PORT=80
ENV PORT=${PORT}
ARG PUBLIC_URL=/pacs/viewer
ENV PUBLIC_URL=${PUBLIC_URL}

# Remove the default Nginx configuration file.
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom Nginx configuration.
# This file should be located at .docker/Viewer-v3.x/nginx.conf in your build context.
COPY .docker/Viewer-v3.x/nginx.conf /etc/nginx/conf.d/nginx.conf

USER nginx
COPY --chown=nginx:nginx .docker/Viewer-v3.x /usr/src
RUN chmod 777 /usr/src/entrypoint.sh

# Copy your built app to the proper location.
COPY ./platform/app/dist /usr/share/nginx/html${PUBLIC_URL}
COPY ./platform/app/dist/assets /usr/share/nginx/html/assets

# In entrypoint.sh, app-config.js might be overwritten, so chmod it to be writeable.
# Change to root to adjust ownership.
USER root
RUN chown -R nginx:nginx /usr/share/nginx/html
USER nginx

ENTRYPOINT ["/usr/src/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
