echo "Making a Neologism release package ..."
rm -rf tmp
mkdir tmp
rm neologism.zip

# Download Drupal Core. Remember to check for new releases at
# http://drupal.org/project/drupal
echo "Downloading Drupal Core ..."
drush dl drupal-6.20
mv drupal-6.* tmp/neologism
cd tmp/neologism

# Download required modules
echo "Downloading required Drupal modules ..."
drush dl cck rdf ext rules

# Download and extract ARC, which is required as part of the RDF module
echo "Downloading ARC ..."
mkdir sites/all/modules/rdf/vendor
curl -L -o sites/all/modules/rdf/vendor/arc.tar.gz http://github.com/semsol/arc2/tarball/master
tar xzf sites/all/modules/rdf/vendor/arc.tar.gz -C sites/all/modules/rdf/vendor/
mv sites/all/modules/rdf/vendor/semsol-arc2-* sites/all/modules/rdf/vendor/arc
rm sites/all/modules/rdf/vendor/arc.tar.gz

# Download and extract Ext JS, which is required for the evoc module 
echo "Downloading Ext JS"
curl -O http://extjs.cachefly.net/ext-3.3.1.zip
unzip -q -n ext-3.*.zip
rm ext-3.*.zip
mv ext-3.* sites/all/modules/ext/ext
echo "Removing unused parts of Ext JS"
rm -rf sites/all/modules/ext/ext/docs
rm -rf sites/all/modules/ext/ext/examples
rm -rf sites/all/modules/ext/ext/pkgs
rm -rf sites/all/modules/ext/ext/src
rm -rf sites/all/modules/ext/ext/test
rm -rf sites/all/modules/ext/ext/welcome

# Export Neologism and evoc modules from Google Code SVN
echo "Getting neologism module from SVN ..."
echo "Getting evoc module from SVN ..."
svn export -q https://neologism.googlecode.com/svn/branches/drupal-6/neologism sites/all/modules/neologism
svn export -q https://neologism.googlecode.com/svn/branches/drupal-6/evoc sites/all/modules/evoc

# Check out Neologism installation profile from Google Code SVN
echo "Getting installation profile from SVN ..."
svn export -q https://neologism.googlecode.com/svn/branches/drupal-6/profile profiles/neologism

# Delete the Drupal default installation profile, we only support the Neologism one
echo "Deleting default installation profile ..."
rm -rf profiles/default/

# Create archive of the entire thing, ready for installation by users
echo "Creating neologism.zip ..."
cd ..
zip -q -r ../neologism.zip neologism
cd ..
