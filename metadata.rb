name             'django'
maintainer       'David Sáenz Tagarro'
maintainer_email 'david.saenz.tagarro@gmail.com'
license          'All rights reserved'
description      'Installs/Configures django-cirujanos'
long_description 'Installs/Configures django-cirujanos'
version          '0.1.0'

# dependencies default recipe

depends "my-environment"

depends "apache2"
depends "database"
depends "python"
depends "mercurial"

# dependencies family recipe

depends "nodejs"
