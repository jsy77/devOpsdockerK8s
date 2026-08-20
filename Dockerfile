FROM nginx

CMD ["sh", "-c", "echo 'Intentional Jenkins rollback test' && exit 1"]
