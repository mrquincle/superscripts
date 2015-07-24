
ifile=${1:? "Input file"}

mkdir -p profile
mkdir -p bio
mkdir -p urls

website=https://www.kickstarter.com

while read i; do
    profile=$(echo "$i" | cut -f1);
    echo $profile
    name=$(echo "$profile" | sed "s|$website/profile/||g")
    echo $name

    echo "Download ${profile}"
    curl -s -X GET $profile -o "profile/$name"

    bio_url_raw=$(cat "profile/$name" | grep "See full bio")

    bio_url=$(echo "$bio_url_raw" | sed 's|<a class="remote_modal_dialog" href="||g' | sed 's|">See full bio & links</a>||g')

    echo "Download ${website}/${bio_url}"
    curl -s -X GET "${website}/${bio_url}" -o "bio/$name"

    backed_raw=$(cat "bio/$name" | grep ^Backed)
    backed=$(echo $backed_raw | cut -f2 -d' ')

    cat "bio/$name" | grep nofollow | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' > "urls/$name"

    urls=$(cat "urls/$name" | tr '\r\n' '\t')

    #echo $bio_url
    #echo $name
    #echo $backed
    #echo $urls

    echo "${bio_url}\t${name}\t${backed}\t${urls}"
    echo "${bio_url}\t${name}\t${backed}\t${urls}" >> profiles.tmp.txt

done < "$ifile"

cat profiles.tmp.txt| sed 's|/profiles/|https://www.kickstarter.com/profiles/|g' > profiles.txt
