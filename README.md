[![dockeri.co](http://dockeri.co/image/weldpua2008/hugo)](https://hub.docker.com/r/weldpua2008/hugo/) [![Build Status](https://travis-ci.org/weldpua2008/docker-hugo.svg?branch=master)](https://travis-ci.org/weldpua2008/docker-hugo) [![](https://images.microbadger.com/badges/image/weldpua2008/hugo.svg)]
docker-hugo
==============

`weldpua2008/hugo` is a [Docker](https://www.docker.io) image for static sites generated with [Hugo](http://gohugo.io) - a fast and modern static website engine. It can either be used to run arbitrary Hugo commands for your project or as a base image for your custom container. 

The default entrypoint runs the plain ```hugo```command. Via command parameters the command which should be used to run Hugo can be selected and parameterized. For example running ```docker run ... fbrx/hugo server -D -F``` will result in running ```hugo server -D -F``` inside the container.


## Environment Variables

* `HUGO_THEME` theme to use 
* `HUGO_WATCH` (set to any value to enable watching)
* `HUGO_BASEURL`  hostname (and path) to the root, e.g. http://spf13.com/

#### Help 
To print Hugo Help:

```bash
docker run --rm -it weldpua2008/hugo hugo help
```

Prerequisites
-------------

The image is based on the following directory structure:

	.
	├── Dockerfile
	└── site
	    ├── config.toml
	    ├── content
	    │   └── ...
	    ├── layouts
	    │   └── ...
	    └── static
		└── ...

In other words, your Hugo site resides in the `site` directory, and you have a simple Dockerfile:

	FROM weldpua2008/hugo 


Building your site
------------------

Based on this structure, you can easily build an image for your site:

Example Dockerfile:
    FROM weldpua2008/hugo:latest
    RUN echo "my image"


	docker build -t my/image .

Your site is automatically generated during this build. 


Using your site
---------------

There are two options for using the image you generated: 

- as a stand-alone image
- as a volume image for your webserver

Using your image as a stand-alone image is the easiest:

	docker run -p 8080:1313 my/image

This will automatically start `hugo server`, and your blog is now available on http://localhost:8080. 

If you are using `boot2docker`, you need to adjust the base URL: 

	docker run -p 1313:1313 -e HUGO_BASE_URL=http://YOUR_DOCKER_IP:1313 my/image

Theis image is also suitable for use as a volume image for a web server, such as [hugo](https://registry.hub.docker.com/weldpua2008/hugo/)

	docker run -d -v /usr/share/nginx/html --name site-data my/image
	docker run -d --volumes-from site-data --name site-server -p 80:1313 weldpua2008/hugo

Example site
--------

Please use the `example` option for the image to test Hugo:

    	docker run -d --name site-server my/image example
    	curl $(docker inspect -f '{{ .NetworkSettings.IPAddress }}' site-server):1313

Create a site with Hugo
--------


    hugo new theme site -s /site
    hugo new site /site



## Issues

If you have any problems with or questions about this docker image, please contact me through a [GitHub issue](https://github.com/weldpua2008/docker-hugo/issues). 
If the issue is related to Hugo itself, please leave an issue on the [Hugo official repository](https://github.com/spf13/hugo).


## Contributing

You are invited to contribute new features, fixes or updates to this container, through a [Github Pull Request](https://github.com/weldpua2008/docker-hugo/pulls).
