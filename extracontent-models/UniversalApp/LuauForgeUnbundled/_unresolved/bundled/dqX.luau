local Players = game:GetService("Players")

local immutable = require("@luauforge/bundled/dqY").Immutable

local fFlagMediaAccordionAndFullTelemetry = require("@luauforge/bundled/dqB").FFlagMediaAccordionAndFullTelemetry
local fFlagLuaAppDesktopMediaGalleryTelemetry = require("@luauforge/bundled/dqB").FFlagLuaAppDesktopMediaGalleryTelemetry

local fFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@luauforge/bundled/dqB").FFlagLuaAppEdpMediaGalleryRedesignTelemetry

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@luauforge/bundled/dqB").FFlagLuaAppAddUniverseIdToGameDetailsEvents

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@luauforge/bundled/dqB").FFlagLuaAppAddUniverseIdToEngagementEvents

local function gameDetailsBasicEvent(p2)
	return function(object, value, value2, p3)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p3) == "table", "Expected state to be a table")

		local v5 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, p2, (immutable.JoinDictionaries(v5, p3)))
	end
end

local function gameDetailsToggleEvent(p2)
	local function fn(object, value, value2, joinDictionaries)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(joinDictionaries) == "table", "Expected state to be a table")

		local v5 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, p2, (immutable.JoinDictionaries(v5, joinDictionaries)))
	end

	return function(p3, p4, p5, p6, options)
		assert(type(p6) == "boolean", "Expected state to be a boolean")

		if options ~= nil then
			assert(type(options) == "table", "Expected extraData to be a table")
		end

		return fn(p3, p4, p5, immutable.JoinDictionaries(options or {}, {
			state = p6 and "on" or "off"
		}))
	end
end

local function gameDetailsSimpleEvent(p2)
	local function fn(object, value, value2, p3)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p3) == "table", "Expected state to be a table")

		local v5 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, p2, (immutable.JoinDictionaries(v5, p3)))
	end

	return function(p3, p4, p5, options)
		return fn(p3, p4, p5, options or {})
	end
end

local v6 = "copyExperienceLink"
local function fn(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(p2) == "table", "Expected state to be a table")

	local v7 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v6, (immutable.JoinDictionaries(v7, p2)))
end

local v5 = {
	CopyExperienceLink = function(p2, p3, p4, options)
		return fn(p2, p3, p4, options or {})
	end,
	Favorite = 0,
	Follow = 0,
	ShareGameToChat = 0,
	GameDetailsSubpage = 0,
	Vote = 0,
	OpenMore = 0,
	OpenPlayTogether = 0,
	CreatePrivateGame = 0,
	JoinFriendsInGame = 0,
	ShareExperienceLink = 0,
	RequestRefundClick = 0,
	MediaGalleryActivated = 0,
	MediaGallerySwiped = 0,
	MediaGalleryClosed = 0,
	MediaGalleryMediaChanged = 0,
	MediaAccordionExpanded = 0,
	MediaAccordionCollapsed = 0,
	MediaGalleryEnterFullscreen = 0,
	MediaGalleryExitFullscreen = 0
}
local v7 = "favorite"
local function fn2(object, value, value2, joinDictionaries)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(joinDictionaries) == "table", "Expected state to be a table")

	local v8 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v7, (immutable.JoinDictionaries(v8, joinDictionaries)))
end

function v5.Favorite(p2, p3, p4, p5, options)
	assert(type(p5) == "boolean", "Expected state to be a boolean")

	if options ~= nil then
		assert(type(options) == "table", "Expected extraData to be a table")
	end

	return fn2(p2, p3, p4, immutable.JoinDictionaries(options or {}, {
		state = p5 and "on" or "off"
	}))
end

local v8 = "follow"
local function fn3(object, value, value2, joinDictionaries)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(joinDictionaries) == "table", "Expected state to be a table")

	local v9 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v8, (immutable.JoinDictionaries(v9, joinDictionaries)))
end

function v5.Follow(p2, p3, p4, p5, options)
	assert(type(p5) == "boolean", "Expected state to be a boolean")

	if options ~= nil then
		assert(type(options) == "table", "Expected extraData to be a table")
	end

	return fn3(p2, p3, p4, immutable.JoinDictionaries(options or {}, {
		state = p5 and "on" or "off"
	}))
end

local v9 = "navigateToInviteFriends"
local function fn4(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(p2) == "table", "Expected state to be a table")

	local v10 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v9, (immutable.JoinDictionaries(v10, p2)))
end

function v5.ShareGameToChat(p2, p3, p4, options)
	return fn4(p2, p3, p4, options or {})
end
function v5.GameDetailsSubpage(p2, p3, p4, p5, universeId)
	local v10 = "gameDetailsSubpage"
	local function fn5(object, value, value2, p6)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p6) == "table", "Expected state to be a table")

		local v11 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, v10, (immutable.JoinDictionaries(v11, p6)))
	end

	if not fFlagLuaAppAddUniverseIdToGameDetailsEvents then
		universeId = nil
	end

	fn5(p2, p3, p4, { subpage = p5, universeId = universeId })
end
function v5.Vote(p2, p3, p4, p5, p6, targetId)
	local v10 = "vote"
	local function fn5(object, value, value2, p7)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p7) == "table", "Expected state to be a table")

		local v11 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, v10, (immutable.JoinDictionaries(v11, p7)))
	end

	if not fFlagLuaAppAddUniverseIdToEngagementEvents then
		targetId = nil
	end

	fn5(p2, p3, p4, { vote = p5, prevVote = p6, targetId = targetId })
end

local v10 = "openMore"
local function fn5(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(p2) == "table", "Expected state to be a table")

	local v11 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v10, (immutable.JoinDictionaries(v11, p2)))
end

function v5.OpenMore(p2, p3, p4, options)
	return fn5(p2, p3, p4, options or {})
end

local v11 = "openGameDetailsPT"
local function fn6(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(p2) == "table", "Expected state to be a table")

	local v12 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v11, (immutable.JoinDictionaries(v12, p2)))
end

function v5.OpenPlayTogether(p2, p3, p4, options)
	return fn6(p2, p3, p4, options or {})
end

local v12 = "createPrivateGame"
local function fn7(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(p2) == "table", "Expected state to be a table")

	local v13 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v12, (immutable.JoinDictionaries(v13, p2)))
end

function v5.CreatePrivateGame(p2, p3, p4, options)
	return fn7(p2, p3, p4, options or {})
end

local v13 = "joinFriendsInGame"
local function fn8(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(p2) == "table", "Expected state to be a table")

	local v14 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v13, (immutable.JoinDictionaries(v14, p2)))
end

function v5.JoinFriendsInGame(p2, p3, p4, options)
	return fn8(p2, p3, p4, options or {})
end

local v14 = "shareExperienceLink"
local function fn9(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(p2) == "table", "Expected state to be a table")

	local v15 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v14, (immutable.JoinDictionaries(v15, p2)))
end

function v5.ShareExperienceLink(p2, p3, p4, options)
	return fn9(p2, p3, p4, options or {})
end

local v15 = "requestRefundClick"
local function fn10(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(p2) == "table", "Expected state to be a table")

	local v16 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v15, (immutable.JoinDictionaries(v16, p2)))
end

function v5.RequestRefundClick(p2, p3, p4, options)
	return fn10(p2, p3, p4, options or {})
end

local v16 = "mediaGalleryActivated"
local function fn11(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(p2) == "table", "Expected state to be a table")

	local v17 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v16, (immutable.JoinDictionaries(v17, p2)))
end

function v5.MediaGalleryActivated(p2, p3, p4, options)
	return fn11(p2, p3, p4, options or {})
end

local v17 = "mediaGallerySwiped"
local function fn12(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(p2) == "table", "Expected state to be a table")

	local v18 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = value2
	}

	object:setRBXEventStream(value, v17, (immutable.JoinDictionaries(v18, p2)))
end

function v5.MediaGallerySwiped(p2, p3, p4, options)
	return fn12(p2, p3, p4, options or {})
end

local fn13

if fFlagMediaAccordionAndFullTelemetry then
	local v18 = "mediaGalleryFullViewClosed"
	local function fn14(object, value, value2, p2)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")

		local v19 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, v18, (immutable.JoinDictionaries(v19, p2)))
	end

	fn13 = function(p2, p3, p4, options)
		return fn14(p2, p3, p4, options or {})
	end
end

v5.MediaGalleryClosed = fn13
local fn14

if fFlagLuaAppDesktopMediaGalleryTelemetry then
	local v18 = "mediaGalleryMediaChanged"
	local function fn15(object, value, value2, p2)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")

		local v19 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, v18, (immutable.JoinDictionaries(v19, p2)))
	end

	fn14 = function(p2, p3, p4, options)
		return fn15(p2, p3, p4, options or {})
	end
end

v5.MediaGalleryMediaChanged = fn14
local fn15

if fFlagMediaAccordionAndFullTelemetry then
	local v18 = "mediaAccordionExpanded"
	local function fn16(object, value, value2, p2)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")

		local v19 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, v18, (immutable.JoinDictionaries(v19, p2)))
	end

	fn15 = function(p2, p3, p4, options)
		return fn16(p2, p3, p4, options or {})
	end
end

v5.MediaAccordionExpanded = fn15
local fn16

if fFlagMediaAccordionAndFullTelemetry then
	local v18 = "mediaAccordionCollapsed"
	local function fn17(object, value, value2, p2)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")

		local v19 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, v18, (immutable.JoinDictionaries(v19, p2)))
	end

	fn16 = function(p2, p3, p4, options)
		return fn17(p2, p3, p4, options or {})
	end
end

v5.MediaAccordionCollapsed = fn16
local fn17

if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
	local v18 = "mediaGalleryEnterFullscreen"
	local function fn18(object, value, value2, p2)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")

		local v19 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, v18, (immutable.JoinDictionaries(v19, p2)))
	end

	fn17 = function(p2, p3, p4, options)
		return fn18(p2, p3, p4, options or {})
	end
end

v5.MediaGalleryEnterFullscreen = fn17
local fn18

if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
	local v18 = "mediaGalleryExitFullscreen"
	local function fn19(object, value, value2, p2)
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")

		local v19 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, v18, (immutable.JoinDictionaries(v19, p2)))
	end

	fn18 = function(p2, p3, p4, options)
		return fn19(p2, p3, p4, options or {})
	end
end

v5.MediaGalleryExitFullscreen = fn18
return v5
