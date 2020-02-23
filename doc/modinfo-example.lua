name =  "Some Mod"
version =  "0.01"
--version_compatible = "0.01"
russian = russian or  ( language ==  "ru" )
description = russian and  "Some description."  or  "Some Description."
forumthread =  ""
author =  ""

api_version =  6
api_version_dst =  10

priority =  0

dont_starve_compatible =  false  --Let it be DST
reign_of_giants_compatible =  false
shipwrecked_compatible =  false
dst_compatible =  true

--icon_atlas = "preview.xml"
--icon = "preview.tex"

all_clients_require_mod =  false  --Let this be the server mod for DST
client_only_mod =  false

--server_filter_tags = {"pvp"}

configuration_options =
{
    {
        name =  "option_name" ,
        label = russian and  "Some option"  or  "Some Option" ,
        hover = russian and  "Hover text"  or  "Text On Mouse Over" ,
        options =  {
            { description = russian and  "option 1"  or  "option 1" , data =  1 } ,
            { description = russianand  "option 2"  or  "option 2" , data =  2 } ,
            { description = russian and  "option 3"  or  "option 3" , data =  3 } ,
        } ,
        default =  1 ,
    } ,
}
