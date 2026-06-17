{ config, lib, pkgs, ... }:
let
  mkTuple = (pkgs.formats.elixirConf {}).lib.mkTuple;
in {
  services.akkoma.config.":pleroma".":mrf_simple".reject = [
    { _elixirType = "tuple"; value = ["13bells.com" "admin posts sandy hook conspiracy theories, vaccine misinformation, transmisia, queermisia"]; }
    { _elixirType = "tuple"; value = ["1611.social" "antisemitism and anti-vax from admin; antisemitic caricatures"]; }
    (mkTuple ["4aem.com" "freeze peach peertube hosting antisemitic content and \"clown world\" dogwhistles"])
    { _elixirType = "tuple"; value = ["5dollah.click" "extreme racism and racial slurs from staff accounts; no listed rules"]; }
    (mkTuple ["adachi.party" "about page features racial slurs and \"kill/behead\" copypasta; rules later updated to require advocacy for racism/fascism/nazism; admin posts racist transmisia"])
    { _elixirType = "tuple"; value = ["adtension.com" "admin posts racism and doubled down when called out"]; }
    { _elixirType = "tuple"; value = ["annihilation.social" "run by same person as dembased.xyz; see dembased.xyz"]; }
    { _elixirType = "tuple"; value = ["dembased.xyz" "block-notification bot; racism and antisemitism from admin and local users"]; }
    { _elixirType = "tuple"; value = ["anon-kenkai.net" "antisemitic caricature on peertube landing page; admin posts anti-pride content"]; }
    { _elixirType = "tuple"; value = ["asbestos.cafe" "racism, ableism, antisemitism from admin; shared a dox attempt; extreme anti-blackness from local users"]; }
    { _elixirType = "tuple"; value = ["bae.st" "run by same person as skippers-bin.com; see skippers-bin.com"]; }
    (mkTuple ["skippers-bin.com" "admin has \"n-word pass\" on profile; runs lolicon and black-fetishism bots; runs major followbot; rejects deletes; confederate flag on another admin's profile"])
    { _elixirType = "tuple"; value = ["banepo.st" "block-notification bot; admin posts antisemitism, homomisia, transmisia, and ableism"]; }
    (mkTuple ["bassam.social" "admin frames opposition to anti-queer discrimination as \"oppression\"; doubled down on permitting bigotry after reports"])
    (mkTuple ["beefyboys.win" "block-notification bot; staff posts \"racism is cool and natural\" with racial slurs"])
    { _elixirType = "tuple"; value = ["boymoder.biz" "anti-indian racism and racist copypasta from admin; staff overlaps with asbestos.cafe"]; }
    { _elixirType = "tuple"; value = ["brainsoap.net" "admin dismissive of white supremacy; nazi humor"]; }
    { _elixirType = "tuple"; value = ["breastmilk.club" "admin posts transmisic sui-bait and spams mutual aid spaces with queermisia"]; }
    { _elixirType = "tuple"; value = ["brighteon.social" "far-right instance connected to the brighteon network"]; }
    { _elixirType = "tuple"; value = ["cachapa.xyz" "admin posts blatant racism and transmisic sui-bait; about page contains slurs; permits lolicon"]; }
    { _elixirType = "tuple"; value = ["cachapa.cc" "same admin/issues as cachapa.xyz"]; }
    { _elixirType = "tuple"; value = ["caekis.love" "extreme anti-black racism and antisemitism including genocide advocacy; participated in queermisic harassment campaign"]; }
    { _elixirType = "tuple"; value = ["cannibal.cafe" "pro-contact admin; staff-endorsed instances include known csam/pro-contact instances"]; }
    { _elixirType = "tuple"; value = ["catgirl.life" "part of waifu hunter club; permits lolicon; used for block-evasion by admin"]; }
    { _elixirType = "tuple"; value = ["peervideo.club" "part of waifu hunter club alongside catgirl.life; same issues"]; }
    { _elixirType = "tuple"; value = ["cawfee.club" "racism including anti-romani posts from admin; anti-vax from admin"]; }
    { _elixirType = "tuple"; value = ["childlove.space" "pro-contact map instance that explicitly allows minors to register"]; }
    { _elixirType = "tuple"; value = ["childlove.su" "same as childlove.space; multiple identified pro-contact users and newgon connections"]; }
    { _elixirType = "tuple"; value = ["clew.lol" "racist memes and slurs from admin; white nationalist users; transmisogynistic harassment with sui-bait"]; }
    { _elixirType = "tuple"; value = ["clubcyberia.co" "anti-black emotes; blatant racism from users; hosts kiwifarms staff; staff publicizes reports against harassment victims"]; }
    { _elixirType = "tuple"; value = ["cottoncandy.cafe" "pro-contact map admin; local bubble endorses other pro-contact instances"]; }
    { _elixirType = "tuple"; value = ["crlf.ninja" "admin encourages sending racist slurs to people who block instances; transmisic dogpile participation; publicizes blocks; antisemitic dogwhistle"]; }
    { _elixirType = "tuple"; value = ["crucible.world" "admin participates in extreme transmisic harassment"]; }
    { _elixirType = "tuple"; value = ["cum.camp" "rejects deletes; block-notification bot; staff posts csa-adjacent content"]; }
    { _elixirType = "tuple"; value = ["cum.salon" "same issues as cum.camp; published dox materials"]; }
    (mkTuple ["cunnyborea.space" "racist pro-contact pedophilia-themed instance; admin bios feature swastikas, \"total ___ death\", racism, and antisemitism"])
    { _elixirType = "tuple"; value = ["decayable.ink" "well-known harassment campaigns; transmisogynistic harassment; racist admin"]; }
    { _elixirType = "tuple"; value = ["detroitriotcity.com" "explicit nazi instance; about page permits racial slurs and anti-lgbt content; permits lolicon"]; }
    { _elixirType = "tuple"; value = ["djsumdog.com" "admin posts blatant transmisia and defends teaching children to be transmisic; jan 6 conspiracy theories"]; }
    { _elixirType = "tuple"; value = ["drinkanddrive.africa" "extreme anti-blackness and antisemitism"]; }
    { _elixirType = "tuple"; value = ["eientei.org" "about page explicitly describes instance as racist and uses slurs; block-notification bot; rejects deletes; antisemitic caricatures from admin"]; }
    { _elixirType = "tuple"; value = ["eveningzoo.club" "transmisia, racism, antisemitism, and white nationalism from admin and users"]; }
    { _elixirType = "tuple"; value = ["feministwiki.org" "admin pedojackets and misgenders trans people; promotes transphobia as moral imperative; terf-focused root domain"]; }
    { _elixirType = "tuple"; value = ["fluf.club" "transmisia and sui-bait from admin; about page recommends other fedinuke instances"]; }
    { _elixirType = "tuple"; value = ["foxgirl.lol" "antisemitic slurs and transmisic slurs from admin"]; }
    { _elixirType = "tuple"; value = ["freak.university" "permits pedophilia and explicitly allows minors (13+); contains untagged sexual depictions of minors and pro-contact users"]; }
    { _elixirType = "tuple"; value = ["pedo.school" "identical rules and issues to freak.university; same instance network"]; }
    { _elixirType = "tuple"; value = ["freeatlantis.com" "far-right maga instance; admin reblogs extreme transmisogyny, anti-vax, qanon"]; }
    { _elixirType = "tuple"; value = ["freespeechextremist.com" "antisemitism, transmisogyny; block-notification bot; rejects deletes; explicit freeze peach policy"]; }
    { _elixirType = "tuple"; value = ["fsebugoutzone.org" "continuation of freespeechextremist.com; same policies and issues"]; }
    { _elixirType = "tuple"; value = ["froth.zone" "blatant racism and racist homomisia; ableism from admin; no rules against hate speech"]; }
    { _elixirType = "tuple"; value = ["gameliberty.club" "permits lolicon; admin posts racist memes; slurs in admin bio"]; }
    { _elixirType = "tuple"; value = ["gearlandia.haus" "transmisic targeted harassment and sui-bait from multiple staff; racist slurs from staff; queermisia; staff posts lolisho"]; }
    { _elixirType = "tuple"; value = ["geofront.rocks" "nazi instance; blatant racist and transmisic slurs; ethno-nationalism; nazi profile from active user"]; }
    { _elixirType = "tuple"; value = ["genderheretics.xyz" "about page explicitly identifies as transmisic; admin posts nsfl medical gore in transmisogynistic context; anti-drag pedojacketing"]; }
    { _elixirType = "tuple"; value = ["gleasonator.com" "admin is an outspoken terf and was head of engineering for truth social; refuses to act on extreme bigotry from local users"]; }
    { _elixirType = "tuple"; value = ["glee.li" "racist harassment, transmisia, and harassment campaign participation from admin; associated with getgle.org"]; }
    { _elixirType = "tuple"; value = ["goyim.social" "anti-black caricatures, antisemitism, holocaust denial, and white pride from primary user"]; }
    { _elixirType = "tuple"; value = ["harpy.faith" "antisemitism and racist slurs from admin; transmisic sui-bait directed at trans women"]; }
    { _elixirType = "tuple"; value = ["h5q.net" "hosts untagged ai-generated photorealistic erotic content; potential legal risk"]; }
    { _elixirType = "tuple"; value = ["haeder.net" "admin blocklist reasons are explicitly queermisic; admin bio has blatant transmisia and anti-woke hashtags"]; }
    { _elixirType = "tuple"; value = ["hitchhiker.social" "sibling instance of djsumdog.com; same admin and issues"]; }
    { _elixirType = "tuple"; value = ["battlepenguin.video" "sibling instance of djsumdog.com; same admin and issues"]; }
    { _elixirType = "tuple"; value = ["iddqd.social" "admin posts anti-black caricatures and supports predatory retaliation against dei; markets instance to 4chan users"]; }
    { _elixirType = "tuple"; value = ["kitsunemimi.club" "racist and transmisic harassment from admin including ttd posts; block-notification bot"]; }
    { _elixirType = "tuple"; value = ["kiwifarms.cc" "official kiwifarms fediverse instance"]; }
    { _elixirType = "tuple"; value = ["kyaruc.moe" "admin posts sui-bait to get on blocklists; attempted dox; racist slurs; ableist harassment"]; }
    { _elixirType = "tuple"; value = ["leafposter.club" "antisemitism, queermisia, swerf, and racist slurs from local users"]; }
    { _elixirType = "tuple"; value = ["liberdon.com" "freeze peach ancap instance; covid misinformation, anti-vax, transmisia, flat-earth, antisemitism, and blatant nazism across users"]; }
    { _elixirType = "tuple"; value = ["ligma.pro" "admin threatened mass violence and animal cruelty; posted gore; bragged about death threats"]; }
    { _elixirType = "tuple"; value = ["loli.church" "racist and antisemitic instance announcement; freeze peach policy; users have uncensored lolicon hentai in profiles"]; }
    { _elixirType = "tuple"; value = ["lolicon.rocks" "owner explicitly claims no content moderation; racist and ableist slurs in owner bio; antisemitism and racism from owner"]; }
    { _elixirType = "tuple"; value = ["lolison.network" "map/pedophilia-focused instance"]; }
    { _elixirType = "tuple"; value = ["lolison.top" "map/pedophilia-focused instance; admin also runs rapemeat.express"]; }
    { _elixirType = "tuple"; value = ["magicka.org" "antisemitism, homomisic slurs, climate denial, and anti-abortion from admin"]; }
    { _elixirType = "tuple"; value = ["marsey.moe" "holocaust denial memes; racism; transmisia from users and staff"]; }
    { _elixirType = "tuple"; value = ["taihou.website" "staff posts rape threats, anti-vax, and racist xenomisia; continuation of marsey.moe staff"]; }
    (mkTuple ["merovingian.club" "self-described \"redpilled exiles\" instance; racist caricatures, deep misogyny, transmisogyny, antisemitism, anti-vax"])
    { _elixirType = "tuple"; value = ["midwaytrades.com" "runs libs of tiktok bot; transmisic and misogynist admin"]; }
    { _elixirType = "tuple"; value = ["mirr0r.city" "paraphilia/pedophilia-focused instance that explicitly welcomes pro-contacts and neo-nazis"]; }
    { _elixirType = "tuple"; value = ["mouse.services" "blatant racist slurs from admin"]; }
    { _elixirType = "tuple"; value = ["morale.ch" "transmisia, antisemitism, and ableist holocaust denial from admin"]; }
    { _elixirType = "tuple"; value = ["mugicha.club" "transmisic harassment, anti-asian slurs, and misogynistic racism from admin; confederate flag users"]; }
    { _elixirType = "tuple"; value = ["natehiggers.online" "domain is a racist spoonerism; blog hosts covid conspiracy theories, violent racist transmisogyny, anti-vax"]; }
    { _elixirType = "tuple"; value = ["narrativerry.xyz" "anti-indian racism; antisemitic conspiracy theories mixed with homomisia and racism from admin"]; }
    { _elixirType = "tuple"; value = ["nobodyhasthe.biz" "predecessor to nationalist.social; same admin and staff"]; }
    { _elixirType = "tuple"; value = ["nationalist.social" "white supremacist and antisemitic admins; nazi-iconography mods; staff encourages using slurs instead of reporting"]; }
    { _elixirType = "tuple"; value = ["peertube.se" "instance self-affiliates with the nordic resistance movement"]; }
    { _elixirType = "tuple"; value = ["shortstacksran.ch" "ethno-fascist harassment and antisemitism from admin; blatant racist slurs from admin and users"]; }
    { _elixirType = "tuple"; value = ["needs.vodka" "continuation of shortstacksran.ch; same admin and issues"]; }
    { _elixirType = "tuple"; value = ["nicecrew.digital" "anti-black racism and antisemitic covid conspiracy from staff; bot that spams racial slurs"]; }
    { _elixirType = "tuple"; value = ["nightshift.social" "anti-black racism and antisemitism from multiple staff members"]; }
    { _elixirType = "tuple"; value = ["nnia.space" "pro-zoosexuality and pro-map instance; allows minors and pro-contact users"]; }
    { _elixirType = "tuple"; value = ["nnia.cc" "claimed continuation of nnia.space; same issues"]; }
    { _elixirType = "tuple"; value = ["noagendasocial.com" "far-right instance connected to the no agenda show; queermisia; ethno-nationalist users"]; }
    { _elixirType = "tuple"; value = ["noagendasocial.nl" "sibling instance of noagendasocial.com"]; }
    { _elixirType = "tuple"; value = ["noagendatube.com" "sibling instance of noagendasocial.com"]; }
    { _elixirType = "tuple"; value = ["noauthority.social" "run by noagendasocial.com admin; transmisia; links to other freeze peach fedinuke instances"]; }
    (mkTuple ["norwoodzero.net" "admin runs transmisic harassment campaigns and recruits users for them; about page has racial slurs and a \"whites only\" banner"])
    { _elixirType = "tuple"; value = ["nyanide.com" "transmisogynistic pedojacketing harassment, extreme racism, and anti-vax harassment from staff"]; }
    { _elixirType = "tuple"; value = ["onionfarms.org" "official kiwifarms and onionfarms community instance"]; }
    { _elixirType = "tuple"; value = ["pawlicker.com" "root domain hosts pro-kiwifarms and transmisic essay; transmisogyny from admin"]; }
    { _elixirType = "tuple"; value = ["pawoo.net" "lolicon-permitting instance with repeated csam incidents left unmoderated"]; }
    { _elixirType = "tuple"; value = ["parcero.bond" "racist slurs, antisemitism, sui-bait, and transmisia from admin"]; }
    { _elixirType = "tuple"; value = ["parcero.casa" "same admin and issues as parcero.bond"]; }
    { _elixirType = "tuple"; value = ["piazza.today" "climate denial, covid misinformation, transmisia, maga, and great replacement conspiracy theories from admin and users"]; }
    { _elixirType = "tuple"; value = ["pibvt.net" "lolisho and actual photos of toddlers posted by map users"]; }
    { _elixirType = "tuple"; value = ["pieville.net" "admin is a white nationalist who explicitly advocates for an ethno-state and genocide; blatant racism and antisemitism"]; }
    { _elixirType = "tuple"; value = ["poa.st" "well-known nazi instance"]; }
    { _elixirType = "tuple"; value = ["poast.org" "affiliated with poa.st"]; }
    { _elixirType = "tuple"; value = ["poast.tv" "affiliated with poa.st"]; }
    { _elixirType = "tuple"; value = ["pisskey.io" "run by poa.st admin; racist, transmisic, and antisemitic harassment"]; }
    { _elixirType = "tuple"; value = ["sad.cab" "also run by poa.st admin; same issues"]; }
    { _elixirType = "tuple"; value = ["poster.place" "staff spams mutual aid spaces with extreme queermisia and racist homomisic posts; slur-filled instance header"]; }
    { _elixirType = "tuple"; value = ["rapemeat.solutions" "openly pro-csa; successor to instance known for posting real csam"]; }
    { _elixirType = "tuple"; value = ["rapemeat.express" "public counterpart to rapemeat.solutions; same admin"]; }
    { _elixirType = "tuple"; value = ["rayci.st" "racial slurs, anti-indian racism, antisemitism, and shock content spam in mutualaid hashtag from admin"]; }
    { _elixirType = "tuple"; value = ["rebelbase.site" "transmisia and misgendering from admin; anti-abortion; mra; covid denial; anti-vax; queermisia from users"]; }
    { _elixirType = "tuple"; value = ["ryona.agency" "racism, antisemitism, transmisogynistic harassment from admin; block-notification bot; rejects deletes; bypasses authorized-fetch"]; }
    { _elixirType = "tuple"; value = ["plagu.ee" "run by ryona.agency admin; same mrf policies and patches"]; }
    { _elixirType = "tuple"; value = ["schwartzwelt.xyz" "admin posts transmisic sui-bait with nazi iconography; anti-indigenous racist harassment"]; }
    { _elixirType = "tuple"; value = ["seal.cafe" "transmisic targeted harassment and racist slurs from admin; antisemitism from users; sui-bait toward trans women"]; }
    { _elixirType = "tuple"; value = ["shaw.app" "admin pedojackets trans people and leaves transmisic replies to trans women; anti-mask"]; }
    { _elixirType = "tuple"; value = ["shitpost.cloud" "racial slurs from admin; publicizes reports made against transmisic harassment targets; racist staff"]; }
    { _elixirType = "tuple"; value = ["skinheads.social" "white-nationalist skinhead network (the antisocial network); white pride, nazi iconography, nordic resistance movement content"]; }
    { _elixirType = "tuple"; value = ["skinheads.eu" "alternate domain for the antisocial network"]; }
    { _elixirType = "tuple"; value = ["skinheads.uk" "alternate domain for the antisocial network"]; }
    { _elixirType = "tuple"; value = ["skinheads.io" "alternate domain for the antisocial network"]; }
    { _elixirType = "tuple"; value = ["spinster.xyz" "terf instance created by gleasonator.com admin; staff openly identifies as terf; transmisogyny"]; }
    { _elixirType = "tuple"; value = ["neenster.org" "shares staff with spinster.xyz; self-described terf content"]; }
    { _elixirType = "tuple"; value = ["strelizia.net" "rejects deletes; block-notification bot; anti-black racism from admin; users with nazi imagery"]; }
    { _elixirType = "tuple"; value = ["subs4social.xyz" "antisemitism, misogyny, racism, transmisia, and white genocide conspiracy from the sole active user"]; }
    { _elixirType = "tuple"; value = ["tastingtraffic.net" "admin repeatedly mass-posts far-right transmisia and queermisia with hashtag spam"]; }
    { _elixirType = "tuple"; value = ["theblab.org" "explicitly permits and admin reblogs nazi and ethno-nationalist content; self-described gab refugee instance"]; }
    { _elixirType = "tuple"; value = ["thechimp.zone" "admin sends transmisic pedojacketing harassment with racial slurs; queermisic harassment; racial slurs in admin profile"]; }
    { _elixirType = "tuple"; value = ["thenobody.club" "transmisogynistic harassment, racist and antisemitic slurs, and xenomisia from admin"]; }
    { _elixirType = "tuple"; value = ["truthsocial.co.in" "far-right maga-themed instance; unmoderated; racist content from primary users"]; }
    { _elixirType = "tuple"; value = ["tsundere.love" "admin is an alt of a loli.church user with explicit lolicon content; extreme anti-blackness and racism"]; }
    { _elixirType = "tuple"; value = ["usualsuspects.lol" "admin led targeted transmisic bodyshaming harassment campaign; created as block-bait instance"]; }
    { _elixirType = "tuple"; value = ["vampiremaid.cafe" "white nationalism, racism, antisemitism with slurs from admin; suggestive lolicon"]; }
    { _elixirType = "tuple"; value = ["varishangout.net" "permits lolicon/shotacon; transmisia and transmisic harassment from staff and members"]; }
    (mkTuple ["volk.network" "\"white power alt-tech\" admin with nazi salute profile photo; white supremacy and antisemitism"])
    { _elixirType = "tuple"; value = ["volk.love" "peertube instance affiliated with volk.network; explicitly white supremacist"]; }
    { _elixirType = "tuple"; value = ["vtuberfan.social" "racism and hate speech from admin; unmarked nudity; racist baiting from users"]; }
    { _elixirType = "tuple"; value = ["wolfgirl.bar" "admin posts nazi content with racial slurs and defends slavery; sends nazi imagery to jewish users"]; }
    { _elixirType = "tuple"; value = ["yggdrasil.social" "about page explicitly bans lgbtq; transmisia; swastika-using national socialist users; racism"]; }
    { _elixirType = "tuple"; value = ["zhub.link" "admin posts queermisia and homomisia unprompted; islamomisic pedojacketing from admin"]; }
    { _elixirType = "tuple"; value = ["absolutelyproprietary.org" "racial slur as admin self-intro; racist caricature threads; alts for crlf.ninja and cum.salon admins; racist slur spam in black mastodon and mutualaid"]; }
    { _elixirType = "tuple"; value = ["baraag.net" "lolicon-focused instance; potential legal risk depending on jurisdiction; consider blocking media only"]; }
    { _elixirType = "tuple"; value = ["berserker.town" "admin refuses to moderate hate speech; permissive policies enable eugenics dogwhistles"]; }
    { _elixirType = "tuple"; value = ["federated.fun" "blatant transmisia from admin"]; }
    { _elixirType = "tuple"; value = ["wikileaks2.org" "continuation of federated.fun admin's activity; queermisia on new instance"]; }
    { _elixirType = "tuple"; value = ["firedragonstudios.com" "previously hosted freeze peach instance with far-right content and anti-vax; got widely blocked before switching domains"]; }
    { _elixirType = "tuple"; value = ["freesoftwareextremist.com" "ableism, antisemitism from users; admin regularly uses anti-chinese and other anti-asian racial slurs; open registration"]; }
    { _elixirType = "tuple"; value = ["freetalklive.com" "self-identified unmoderated instance connected to libertarian free talk live show"]; }
    { _elixirType = "tuple"; value = ["kawa-kun.net" "rejects deletes"]; }
    { _elixirType = "tuple"; value = ["kompost.cz" "racism, transmisia, queermisia from admin"]; }
    { _elixirType = "tuple"; value = ["krackhou.se" "admin posts racist tnd content and racial slurs"]; }
    { _elixirType = "tuple"; value = ["maladaptive.art" "racism, transmisia, and antisemitism from local user"]; }
    { _elixirType = "tuple"; value = ["novoa.nagoya" "antisemitism from admin"]; }
    { _elixirType = "tuple"; value = ["occultist.space" "run by usualsuspects.lol admin"]; }
    { _elixirType = "tuple"; value = ["enjoyer.network" "run by usualsuspects.lol admin"]; }
    { _elixirType = "tuple"; value = ["peister.org" "admin's pinned post and profile are explicitly terf/gender-critical"]; }
    { _elixirType = "tuple"; value = ["shitposter.club" "transmisia, white supremacy, racism, eugenics from multiple users; freeze peach admin; racist admin"]; }
    { _elixirType = "tuple"; value = ["shitposter.world" "successor to shitposter.club; same issues; rejects deletes"]; }
    { _elixirType = "tuple"; value = ["shota.house" "freeze peach instance permitting lolicon; staff defends bigotry; racist black fetishism from users"]; }
    { _elixirType = "tuple"; value = ["burger.rodeo" "sibling instance to shota.house; same policies and staff"]; }
    { _elixirType = "tuple"; value = ["soc0.outrnat.nl" "self-professed fascist admin; alleges reverse-racism; csem accusations against users; encourages hashtag spam"]; }
    (mkTuple ["someotherguy.xyz" "xenomisic \"build the wall\" admin; queermisic pedojacketing"])
    { _elixirType = "tuple"; value = ["starnix.network" "staff includes admin of dembased.xyz and annihilation.social"]; }
    { _elixirType = "tuple"; value = ["whinge.town" "racism and ableist misogyny from staff"]; }
    { _elixirType = "tuple"; value = ["whinge.house" "same admin and issues as whinge.town"]; }
    { _elixirType = "tuple"; value = ["wideboys.org" "affiliated with and part of same network as beefyboys.win; staff and member overlap"]; }
  ];
}
