# Usage

Create a directory with contents:

	mkdir -p ~/.mailchimp/contents

Create a post for your campaign with your favorite editor, e.g. on privacy.

	vim ~/.mailchimp/contents/30-09-2021-privacy.md

If you want images in the newsletter, go to mailchimpchimp and upload the images there. Then use the link in the text.

After you've finished writing, create an .html from the .md file by:

	mkdir campaigns
	./fill_campaign ~/.mailchimp/contents/30-09-2021-privacy.md mailchimp-template.html ~/.mail/campaigns/30-09-2021-privacy.html

Finally, create a mailchimpchimp campaign online by uploading the result:

	./create_campaign.sh ~/.mailchimp/campaigns/30-09-2021-privacy.html

Go online, check if there has been anything out of place and press the button!

# Installation

The installation requires `mc` and `showdown` as command-line utilities.

You can download `mc` via `gem`. The source can be found at <https://github.com/kale/mc>.

	gem install mc

Likewise, `showdown` can also be installed as a `gem`.

	gem install showdown

Last tested in 2021.
