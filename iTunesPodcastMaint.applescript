-- first lets check if iTunes is already running,...
tell application "System Events"
	if (name of processes) does not contain "iTunes" then
		-- if it is not running then do nothing but report it
		return "iTunes is not currently running."
	end if
end tell

RegisterWithGrowl()
set msg to DisablePlayedPodcasts("Podcasts")

set msg to msg & FixSkipShuffle("Podcasts")
set msg to msg & DisableLongTracksInAlbums(600, "Discovery News (audio)")
set msg to msg & setPodcastToPlayed("CNN", "Podcasts")
set msg to msg & setPodcastToPlayed("NPR News", "Podcasts")

if length of msg is greater than 0 then
	set msg to "iTunes Maintenance complete!
" & msg
	SendCompletionGrowl(msg)
else
	set msg to "Nothing to do!"
end if

return msg

-- set the played attribute to all podcasts
on setPodcastToPlayed(podcastPrefix, podcastPlaylistName)
	set ret to ""
	tell application "iTunes"
		set podcastPlaylist to (get the last playlist whose name is podcastPlaylistName)
		set allTracks to every track in podcastPlaylist whose (unplayed is true) and (name starts with podcastPrefix)
		repeat with thisTrack in allTracks
			set ret to ret & " setting played to " & name of thisTrack & "
"
			set unplayed of thisTrack to false
		end repeat
	end tell
	return ret
end setPodcastToPlayed

on DisablePlayedPodcasts(playlistName)
	set ret to ""
	tell application "iTunes"
		set podcastPlaylist to (get the last playlist whose name is playlistName)
		set allTracks to every track in podcastPlaylist whose (enabled is true) and (played count > 0)
		repeat with thisTrack in allTracks
			set ret to ret & " disabling " & name of thisTrack & "
"
			set enabled of thisTrack to false
		end repeat
	end tell
	return ret
end DisablePlayedPodcasts

-- disable podcast episodes that are longer than a certain amount
on DisableLongTracksInAlbums(maxLength, podcastName)
	set ret to ""
	tell application "iTunes"
		-- get the iTunes Library Playlist
		set iTunesLibrary to library playlist 1
		
		-- use the search method to quickly find tracks with the search name
		set allPodcastEpisodes to reverse of (search iTunesLibrary for podcastName only albums)
		repeat with t in allPodcastEpisodes
			if (enabled of t is true) and (duration of t > maxLength) then
				set enabled of t to false
				set ret to ret & "Disabling " & name of t & "
"
			end if
		end repeat
	end tell
	return ret
end DisableLongTracksInAlbums

(*
http://applescriptsourcebook.com/viewtopic.php?pid=46830
*)
on FixSkipShuffle(playlistName)
	set ret to ""
	tell application "iTunes"
		set podcastPlaylist to (get the last playlist whose name is playlistName)
		set allTracks to every track in podcastPlaylist whose enabled is true and shufflable is false
		repeat with thisTrack in allTracks
			if thisTrack is not shufflable then
				set ret to "Fixing Shufflable for " & name of thisTrack & "
"
				set shufflable of thisTrack to true
			end if
		end repeat
	end tell
	return ret
end FixSkipShuffle

-- returns a status message, every track after keepMostRecentNum will be disabled
on DisableOlderByDownloadTime(keepMostRecentNum, podcastName)
	set ret to ""
	tell application "iTunes"
		-- get the iTunes Library Playlist
		set iTunesLibrary to library playlist 1
		
		-- use the search method to quickly find tracks with the search name
		set allPodcastEpisodes to reverse of (search iTunesLibrary for podcastName only albums)
		set i to 0
		repeat with t in allPodcastEpisodes
			set i to i + 1
			if i > keepMostRecentNum and enabled of t is true then
				set n to name of t
				set ret to ret & "Disabling " & name of t & "
"
				set enabled of t to false
			end if
		end repeat
	end tell
	return ret
end DisableOlderByDownloadTime

on RegisterWithGrowl()
	tell application "GrowlHelperApp"
		-- Make a list of all the notification types 
		-- that this script will ever send:
		set the allNotificationsList to Â
			{"iTunesMaint Completion"}
		
		-- Register our script with growl.
		register as application Â
			"iTunesMaint" all notifications allNotificationsList Â
			default notifications allNotificationsList Â
			icon of application "Script Editor"
	end tell
end RegisterWithGrowl

on SendCompletionGrowl(msg)
	tell application "GrowlHelperApp"
		--	Send a Notification...
		notify with name "iTunesMaint Completion" title Â
			"iTunesMaint Completion" description msg application name "iTunesMaint"
	end tell
end SendCompletionGrowl
