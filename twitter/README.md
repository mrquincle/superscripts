# Sensei

The scripts in this folder are meant to obtain data from twitter and other publicly available sites to help people with sporting.

# Configuration

The file `twitter.config`, has several fields that can be set.

A search term for twitter, here %23 is the hash-symbol:

    term=%23endomondo

Localisation is possible by limiting the search to a location (lat, long) and a certain range:

    geocode=51.0,4.0,200km

And the working directory, where tweets will be stored:

    data_dir="/data/tweets"

# Installation

Install `node`, and `npm` using your operating system's package manager, then:

    npm install -g underscore-cli
    npm install -g jsontools

Besides this, a curl variant is used, so install `twurl`:

    https://github.com/twitter/twurl

This will also require you to set up the OAUTH keys for the twitter API, see the above github page for more information.

# Run

After the configuration, just run the script:

    ./getdata.sh 

This will call the scripts `twitter.sh`, `extract.sh`, and `weather.sh` in order.

Note! It will collect twitter data only after the `since_id` given in `data_dir/since_id`. If this is set to the most recent twitter id, you will not receive any more recent tweets of course! Remove the file, if you don't want to update for as far back as twitter allows.

To collect the data into a nice table run:

    ./create_table.sh

Have fun!

# Copyrights

Author: Anne van Rossum
Copyrights: Almende B.V.
LIcense: LGPLv3+
