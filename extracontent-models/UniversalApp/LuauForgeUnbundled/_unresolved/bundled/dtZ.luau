local Players = game:GetService("Players")

local immutable = require("@luauforge/bundled/dua").Immutable
local discoveryEventErrorLogger = require("@luauforge/bundled/dtM").DiscoveryEventErrorLogger

local fFlagMediaAccordionAndFullTelemetry = require("@luauforge/bundled/dtD").FFlagMediaAccordionAndFullTelemetry
local fFlagLuaAppDesktopMediaGalleryTelemetry = require("@luauforge/bundled/dtD").FFlagLuaAppDesktopMediaGalleryTelemetry

local fFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@luauforge/bundled/dtD").FFlagLuaAppEdpMediaGalleryRedesignTelemetry

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@luauforge/bundled/dtD").FFlagLuaAppAddUniverseIdToGameDetailsEvents

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@luauforge/bundled/dtD").FFlagLuaAppAddUniverseIdToEngagementEvents

local fFlagLuaAppGameDetailsEventsReportInvalidArgs = require("@luauforge/bundled/dtD").FFlagLuaAppGameDetailsEventsReportInvalidArgs

local function gameDetailsBasicEvent(p2)
	return function(object, value, value2, p3)
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v5

			if type(value) ~= "string" then
				v5 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v5 = "Expected placeId to be a string"
			else
				v5 = if type(p3) ~= "table" then "Expected state to be a table" else nil
			end

			if v5 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v5, {
					eventName = p2,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(p3) == "table", "Expected state to be a table")
		end

		local v5 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = value2
		}

		object:setRBXEventStream(value, p2, (immutable.JoinDictionaries(v5, p3)))
	end
end

local function gameDetailsToggleEvent(p2)
	local function fn(object, value, value2, joinDictionaries)
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v5

			if type(value) ~= "string" then
				v5 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v5 = "Expected placeId to be a string"
			else
				v5 = if type(joinDictionaries) ~= "table" then "Expected state to be a table" else nil
			end

			if v5 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v5, {
					eventName = p2,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(joinDictionaries) == "table", "Expected state to be a table")
		end

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
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v5

			if type(value) ~= "string" then
				v5 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v5 = "Expected placeId to be a string"
			else
				v5 = if type(p3) ~= "table" then "Expected state to be a table" else nil
			end

			if v5 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v5, {
					eventName = p2,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(p3) == "table", "Expected state to be a table")
		end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v7

		if type(value) ~= "string" then
			v7 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v7 = "Expected placeId to be a string"
		else
			v7 = if type(p2) ~= "table" then "Expected state to be a table" else nil
		end

		if v7 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v7, {
				eventName = v6,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")
	end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v8

		if type(value) ~= "string" then
			v8 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v8 = "Expected placeId to be a string"
		else
			v8 = if type(joinDictionaries) ~= "table" then "Expected state to be a table" else nil
		end

		if v8 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v8, {
				eventName = v7,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(joinDictionaries) == "table", "Expected state to be a table")
	end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v9

		if type(value) ~= "string" then
			v9 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v9 = "Expected placeId to be a string"
		else
			v9 = if type(joinDictionaries) ~= "table" then "Expected state to be a table" else nil
		end

		if v9 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v9, {
				eventName = v8,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(joinDictionaries) == "table", "Expected state to be a table")
	end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v10

		if type(value) ~= "string" then
			v10 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v10 = "Expected placeId to be a string"
		else
			v10 = if type(p2) ~= "table" then "Expected state to be a table" else nil
		end

		if v10 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v10, {
				eventName = v9,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")
	end

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
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v11

			if type(value) ~= "string" then
				v11 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v11 = "Expected placeId to be a string"
			else
				v11 = if type(p6) ~= "table" then "Expected state to be a table" else nil
			end

			if v11 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v11, {
					eventName = v10,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(p6) == "table", "Expected state to be a table")
		end

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
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v11

			if type(value) ~= "string" then
				v11 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v11 = "Expected placeId to be a string"
			else
				v11 = if type(p7) ~= "table" then "Expected state to be a table" else nil
			end

			if v11 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v11, {
					eventName = v10,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(p7) == "table", "Expected state to be a table")
		end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v11

		if type(value) ~= "string" then
			v11 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v11 = "Expected placeId to be a string"
		else
			v11 = if type(p2) ~= "table" then "Expected state to be a table" else nil
		end

		if v11 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v11, {
				eventName = v10,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")
	end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v12

		if type(value) ~= "string" then
			v12 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v12 = "Expected placeId to be a string"
		else
			v12 = if type(p2) ~= "table" then "Expected state to be a table" else nil
		end

		if v12 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v12, {
				eventName = v11,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")
	end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v13

		if type(value) ~= "string" then
			v13 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v13 = "Expected placeId to be a string"
		else
			v13 = if type(p2) ~= "table" then "Expected state to be a table" else nil
		end

		if v13 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v13, {
				eventName = v12,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")
	end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v14

		if type(value) ~= "string" then
			v14 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v14 = "Expected placeId to be a string"
		else
			v14 = if type(p2) ~= "table" then "Expected state to be a table" else nil
		end

		if v14 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v14, {
				eventName = v13,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")
	end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v15

		if type(value) ~= "string" then
			v15 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v15 = "Expected placeId to be a string"
		else
			v15 = if type(p2) ~= "table" then "Expected state to be a table" else nil
		end

		if v15 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v15, {
				eventName = v14,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")
	end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v16

		if type(value) ~= "string" then
			v16 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v16 = "Expected placeId to be a string"
		else
			v16 = if type(p2) ~= "table" then "Expected state to be a table" else nil
		end

		if v16 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v16, {
				eventName = v15,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")
	end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v17

		if type(value) ~= "string" then
			v17 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v17 = "Expected placeId to be a string"
		else
			v17 = if type(p2) ~= "table" then "Expected state to be a table" else nil
		end

		if v17 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v17, {
				eventName = v16,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")
	end

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
	if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
		local v18

		if type(value) ~= "string" then
			v18 = "Expected eventContext to be a string"
		elseif type(value2) ~= "string" then
			v18 = "Expected placeId to be a string"
		else
			v18 = if type(p2) ~= "table" then "Expected state to be a table" else nil
		end

		if v18 then
			discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v18, {
				eventName = v17,
				eventContext = tostring(value)
			})

			return
		end
	else
		assert(type(value) == "string", "Expected eventContext to be a string")
		assert(type(value2) == "string", "Expected placeId to be a string")
		assert(type(p2) == "table", "Expected state to be a table")
	end

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
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v19

			if type(value) ~= "string" then
				v19 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v19 = "Expected placeId to be a string"
			else
				v19 = if type(p2) ~= "table" then "Expected state to be a table" else nil
			end

			if v19 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v19, {
					eventName = v18,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(p2) == "table", "Expected state to be a table")
		end

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
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v19

			if type(value) ~= "string" then
				v19 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v19 = "Expected placeId to be a string"
			else
				v19 = if type(p2) ~= "table" then "Expected state to be a table" else nil
			end

			if v19 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v19, {
					eventName = v18,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(p2) == "table", "Expected state to be a table")
		end

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
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v19

			if type(value) ~= "string" then
				v19 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v19 = "Expected placeId to be a string"
			else
				v19 = if type(p2) ~= "table" then "Expected state to be a table" else nil
			end

			if v19 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v19, {
					eventName = v18,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(p2) == "table", "Expected state to be a table")
		end

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
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v19

			if type(value) ~= "string" then
				v19 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v19 = "Expected placeId to be a string"
			else
				v19 = if type(p2) ~= "table" then "Expected state to be a table" else nil
			end

			if v19 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v19, {
					eventName = v18,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(p2) == "table", "Expected state to be a table")
		end

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
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v19

			if type(value) ~= "string" then
				v19 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v19 = "Expected placeId to be a string"
			else
				v19 = if type(p2) ~= "table" then "Expected state to be a table" else nil
			end

			if v19 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v19, {
					eventName = v18,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(p2) == "table", "Expected state to be a table")
		end

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
		if fFlagLuaAppGameDetailsEventsReportInvalidArgs then
			local v19

			if type(value) ~= "string" then
				v19 = "Expected eventContext to be a string"
			elseif type(value2) ~= "string" then
				v19 = "Expected placeId to be a string"
			else
				v19 = if type(p2) ~= "table" then "Expected state to be a table" else nil
			end

			if v19 then
				discoveryEventErrorLogger.reportError("GameDetailsEventInvalidArgs", v19, {
					eventName = v18,
					eventContext = tostring(value)
				})

				return
			end
		else
			assert(type(value) == "string", "Expected eventContext to be a string")
			assert(type(value2) == "string", "Expected placeId to be a string")
			assert(type(p2) == "table", "Expected state to be a table")
		end

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
