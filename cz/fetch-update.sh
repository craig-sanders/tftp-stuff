#! /bin/sh

config_site=$(awk -F'[[:space:]]*=[[:space:]]*' '$1 == "SOURCEFORGE" {print $2}' ../config | tail -n 1)
dl_site=$(printf "%s\n" "$config_site" | sed -e 's/\/$//g')

# can only seem to list the available files on sourceforge.net itself,
# not on the dl mirrors.
ls_site='https://sourceforge.net'

#vers="${1:---latest}"
vers="${1:--l}"
dist="${2:-stable}"
arch="${3:-amd64}"

case "$(pwd)" in 
  *cz*) project='clonezilla' ; sep1='_' ; sep2='-' ;;
  *gp*) project='gparted'    ; sep1='-' ; sep2='-' ;;
esac

if [ "$vers" = "--latest" ] ; then
  vers=$($0 -l | head -n 1)
fi

# ls_url .../projects/gparted/files/gparted-live-stable/0.26.1-1/
# dl_url .../gparted/gparted-live-stable/0.26.1-1/gparted-live-0.26.1-1-amd64.zip
#
# ls_url .../projects/clonezilla/files/clonezilla-live-stable/2.4.7-8/
# dl_url .../clonezilla/clonezilla_live_stable/2.4.7-8/clonezilla-live-2.4.7-8-amd64.zip

base_dir="${project}${sep1}live${sep1}${dist}"
filename="${project}${sep2}live${sep2}${vers}${sep2}${arch}.zip"

ls_url="$ls_site/projects/${project}/files/${base_dir}"
dl_url="$dl_site/$project/$base_dir/$vers/$filename"

declare -a lynxargs=(-accept_all_cookies -dump -listonly -nonumbers)

if [ "$vers" = "-l" ] ; then
  lynx "${lynxargs[@]}" "$ls_url/" |
    awk -F/ "/$basefile\/[0-9]/ && ! /stats/ {print \$(NF-1)}" |
    head
  exit 0
fi

url="${base_url}/${vers}/${filename}"

echo wget -q --show-progress -O "$filename" "$dl_url"
wget -q --show-progress -O "$filename" "$dl_url"
