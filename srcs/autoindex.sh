if [ "$1" = "on" ]; then
	sed -i 38's/\boff/on/' /etc/nginx/sites-available/localhost && \
	nginx -s reload
elif [ "$1" = "off" ]; then
	sed -i 38's/\bon/off/' /etc/nginx/sites-available/localhost && \
	nginx -s reload
fi
