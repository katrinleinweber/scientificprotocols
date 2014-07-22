### ScientificProtocols.org - GitHub for Scientific Protocols

[![Build Status](https://travis-ci.org/sprotocols/scientificprotocols.svg?branch=master)](https://travis-ci.org/sprotocols/scientificprotocols)

The core codebase for the [ScientificProtocols.org](https://www.scientificprotocols.org) website. The purpose of this site is to provide a free
and easy way for scientists to publish and collaborate on scientific protocols. By sharing scientific protocols we hope to encourage transparency in
research and promote reproducibility of published results. [ScientificProtocols.org](https://www.scientificprotocols.org)
is part of the [Reproducibility Initiative](http://validation.scienceexchange.com/#/reproducibility-initiative).

The site is heavily focused on GitHub integration. GitHub provides a rock solid foundation for scientific collaboration. Every protocol
created on the [ScientificProtocols.org](https://www.scientificprotocols.org) website is also a [GitHub Gist](https://help.github.com/articles/about-gists).

The core website codebase has been made open source ([MIT License](http://opensource.org/licenses/MIT)) as part of the [Mozilla Science Lab Global Sprint](http://mozillascience.org/).

Thank you to [Science Exchange](https://www.scienceexchange.com) for their support and input on the site and for their general support
of all initiatives dedicated to making researchers lives easier and improving the quality of scientific research.

### Getting started
**Database**

Create a database.yml file in the config directory. Copy the template supplied in database.yml.example into your database.yml file 
and complete the missing information as per your local and remote database settings.

**Settings**

[ScientificProtocols.org](https://www.scientificprotocols.org) uses the [Choices Gem](https://github.com/mislav/choices) to handle
settings in the application. Create a file called settings.local.yml in the config directory. Create a dev and test section in this
file and populate it with the required third party API keys and any other settings stored in the settings.yml file. Make sure when
deploying remotely to setup the required env variables.

If you plan to use the site as is at the very minimum you will require API keys for the following:
- [GitHub API](https://developer.github.com/v3/gists/) with Gist creation permission.
- [Postmark API](http://developer.postmarkapp.com/developer-build.html).
- [Amazon AWS](http://aws.amazon.com/documentation/).

### License
[ScientificProtocols.org](https://www.scientificprotocols.org) is licensed under the [MIT License](http://opensource.org/licenses/MIT).




