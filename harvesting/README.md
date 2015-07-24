# Getting websites of backers on Kickstarter

To kickstart the PR for the Kickstarter we planned, I thought it would be nice to contact a group of people that might be interested in the product.

What other group than Kickstarters who are already backing similar products?

But how to reach them?

## Parse backers from raw html

If you use as input the content of a particular kickstarter project (/backers), either by `wget`, `curl`, or copying it from the website, you can subsequently feed it into the `./parse_backers.sh` script.

The result will be a list of profile urls and names of backers (the nickname or their real name they use on Kickstarter).

## Get home pages of backers

Now, you can visit each profile url. However, you can also use the second script, `./get_bio.sh` with the output of the previous script. The result will be a list of pages that are uploaded by the backers themselves as being interesting to their bio page visitor.

## Visit their website

Now, you will still need to visit the website of each and individual backer. This is not automated.

Good luck to you if you are willing to do this! Of course, be nice to each individual and send them a personal message. You have already spend so much time now to get to their website, you might as well treat them as kings and queens.

Success!


