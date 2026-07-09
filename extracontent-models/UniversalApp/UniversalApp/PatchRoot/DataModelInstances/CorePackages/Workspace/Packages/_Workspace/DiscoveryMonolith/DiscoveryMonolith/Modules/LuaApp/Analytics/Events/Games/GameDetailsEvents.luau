local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Immutable = require(Parent.AppCommonLib).Immutable
local FFlagMediaAccordionAndFullTelemetry = require(Parent.SharedFlags).FFlagMediaAccordionAndFullTelemetry
local FFlagLuaAppDesktopMediaGalleryTelemetry = require(Parent.SharedFlags).FFlagLuaAppDesktopMediaGalleryTelemetry
local FFlagLuaAppEdpMediaGalleryRedesignTelemetry = require(Parent.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignTelemetry
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = require(Parent.SharedFlags).FFlagLuaAppAddUniverseIdToGameDetailsEvents

local function gameDetailsBasicEvent(p1) -- line: 15
	-- upvalues: Players (copy), Immutable (copy)
	return function(p2, p3, p4, p5) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), p1 (copy)
		assert(type(p3) == "string", "Expected eventContext to be a string")
		assert(type(p4) == "string", "Expected placeId to be a string")
		assert(type(p5) == "table", "Expected state to be a table")

		local t1 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p4
		}
		local v260 = Immutable.JoinDictionaries(t1, p5)

		p2:setRBXEventStream(p3, p1, v260)
	end
end
local function gameDetailsToggleEvent(p6) -- line: 34
	-- upvalues: Players (copy), Immutable (copy)
	local function v56(p7, p8, p9, p10) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), p6 (copy)
		assert(type(p8) == "string", "Expected eventContext to be a string")
		assert(type(p9) == "string", "Expected placeId to be a string")
		assert(type(p10) == "table", "Expected state to be a table")

		local t2 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p9
		}
		local v266 = Immutable.JoinDictionaries(t2, p10)

		p7:setRBXEventStream(p8, p6, v266)
	end

	return function(p11, p12, p13, p14, p15) -- line: 36
		-- upvalues: Immutable (copy), v56 (copy)
		assert(type(p14) == "boolean", "Expected state to be a boolean")

		if p15 ~= nil then
			assert(type(p15) == "table", "Expected extraData to be a table")
		end

		local v272 = Immutable.JoinDictionaries(p15 or {}, {
			state = not p14 and "off" or "on"
		})

		return v56(p11, p12, p13, v272)
	end
end
local function gameDetailsSimpleEvent(p16) -- line: 50
	-- upvalues: Players (copy), Immutable (copy)
	local function v58(p17, p18, p19, p20) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), p16 (copy)
		assert(type(p18) == "string", "Expected eventContext to be a string")
		assert(type(p19) == "string", "Expected placeId to be a string")
		assert(type(p20) == "table", "Expected state to be a table")

		local t3 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p19
		}
		local v278 = Immutable.JoinDictionaries(t3, p20)

		p17:setRBXEventStream(p18, p16, v278)
	end

	return function(p21, p22, p23, p24) -- line: 52
		-- upvalues: v58 (copy)
		return v58(p21, p22, p23, p24 or {})
	end
end

local t4 = {}
local s1 = "copyExperienceLink"

local function v13(p25, p26, p27, p28) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s1 (copy)
	assert(type(p26) == "string", "Expected eventContext to be a string")
	assert(type(p27) == "string", "Expected placeId to be a string")
	assert(type(p28) == "table", "Expected state to be a table")

	local t5 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p27
	}
	local v64 = Immutable.JoinDictionaries(t5, p28)

	p25:setRBXEventStream(p26, s1, v64)
end

function t4.CopyExperienceLink(p29, p30, p31, p32) -- line: 52
	-- upvalues: v13 (copy)
	return v13(p29, p30, p31, p32 or {})
end

local s2 = "favorite"

local function v15(p33, p34, p35, p36) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s2 (copy)
	assert(type(p34) == "string", "Expected eventContext to be a string")
	assert(type(p35) == "string", "Expected placeId to be a string")
	assert(type(p36) == "table", "Expected state to be a table")

	local t6 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p35
	}
	local v74 = Immutable.JoinDictionaries(t6, p36)

	p33:setRBXEventStream(p34, s2, v74)
end

function t4.Favorite(p37, p38, p39, p40, p41) -- line: 36
	-- upvalues: Immutable (copy), v15 (copy)
	assert(type(p40) == "boolean", "Expected state to be a boolean")

	if p41 ~= nil then
		assert(type(p41) == "table", "Expected extraData to be a table")
	end

	local v80 = Immutable.JoinDictionaries(p41 or {}, {
		state = not p40 and "off" or "on"
	})

	return v15(p37, p38, p39, v80)
end

local s3 = "follow"

local function v17(p42, p43, p44, p45) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s3 (copy)
	assert(type(p43) == "string", "Expected eventContext to be a string")
	assert(type(p44) == "string", "Expected placeId to be a string")
	assert(type(p45) == "table", "Expected state to be a table")

	local t7 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p44
	}
	local v86 = Immutable.JoinDictionaries(t7, p45)

	p42:setRBXEventStream(p43, s3, v86)
end

function t4.Follow(p46, p47, p48, p49, p50) -- line: 36
	-- upvalues: Immutable (copy), v17 (copy)
	assert(type(p49) == "boolean", "Expected state to be a boolean")

	if p50 ~= nil then
		assert(type(p50) == "table", "Expected extraData to be a table")
	end

	local v92 = Immutable.JoinDictionaries(p50 or {}, {
		state = not p49 and "off" or "on"
	})

	return v17(p46, p47, p48, v92)
end

local s4 = "navigateToInviteFriends"

local function v19(p51, p52, p53, p54) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s4 (copy)
	assert(type(p52) == "string", "Expected eventContext to be a string")
	assert(type(p53) == "string", "Expected placeId to be a string")
	assert(type(p54) == "table", "Expected state to be a table")

	local t8 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p53
	}
	local v98 = Immutable.JoinDictionaries(t8, p54)

	p51:setRBXEventStream(p52, s4, v98)
end

function t4.ShareGameToChat(p55, p56, p57, p58) -- line: 52
	-- upvalues: v19 (copy)
	return v19(p55, p56, p57, p58 or {})
end
function t4.GameDetailsSubpage(p59, p60, p61, p62, p63) -- line: 62
	-- upvalues: Players (copy), Immutable (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy)
	local s5 = "gameDetailsSubpage";

	(function(p64, p65, p66, p67) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), s5 (copy)
		assert(type(p65) == "string", "Expected eventContext to be a string")
		assert(type(p66) == "string", "Expected placeId to be a string")
		assert(type(p67) == "table", "Expected state to be a table")

		local t9 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p66
		}
		local v288 = Immutable.JoinDictionaries(t9, p67)

		p64:setRBXEventStream(p65, s5, v288)
	end)(p59, p60, p61, {
		subpage = p62,
		universeId = if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else p63
	})
end
function t4.Vote(p68, p69, p70, p71, p72) -- line: 68
	-- upvalues: Players (copy), Immutable (copy)
	local s6 = "vote";

	(function(p73, p74, p75, p76) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), s6 (copy)
		assert(type(p74) == "string", "Expected eventContext to be a string")
		assert(type(p75) == "string", "Expected placeId to be a string")
		assert(type(p76) == "table", "Expected state to be a table")

		local t10 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p75
		}
		local v294 = Immutable.JoinDictionaries(t10, p76)

		p73:setRBXEventStream(p74, s6, v294)
	end)(p68, p69, p70, {
		vote = p71,
		prevVote = p72
	})
end

local s7 = "openMore"

local function v21(p77, p78, p79, p80) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s7 (copy)
	assert(type(p78) == "string", "Expected eventContext to be a string")
	assert(type(p79) == "string", "Expected placeId to be a string")
	assert(type(p80) == "table", "Expected state to be a table")

	local t11 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p79
	}
	local v120 = Immutable.JoinDictionaries(t11, p80)

	p77:setRBXEventStream(p78, s7, v120)
end

function t4.OpenMore(p81, p82, p83, p84) -- line: 52
	-- upvalues: v21 (copy)
	return v21(p81, p82, p83, p84 or {})
end

local s8 = "openGameDetailsPT"

local function v23(p85, p86, p87, p88) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s8 (copy)
	assert(type(p86) == "string", "Expected eventContext to be a string")
	assert(type(p87) == "string", "Expected placeId to be a string")
	assert(type(p88) == "table", "Expected state to be a table")

	local t12 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p87
	}
	local v130 = Immutable.JoinDictionaries(t12, p88)

	p85:setRBXEventStream(p86, s8, v130)
end

function t4.OpenPlayTogether(p89, p90, p91, p92) -- line: 52
	-- upvalues: v23 (copy)
	return v23(p89, p90, p91, p92 or {})
end

local s9 = "createPrivateGame"

local function v25(p93, p94, p95, p96) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s9 (copy)
	assert(type(p94) == "string", "Expected eventContext to be a string")
	assert(type(p95) == "string", "Expected placeId to be a string")
	assert(type(p96) == "table", "Expected state to be a table")

	local t13 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p95
	}
	local v140 = Immutable.JoinDictionaries(t13, p96)

	p93:setRBXEventStream(p94, s9, v140)
end

function t4.CreatePrivateGame(p97, p98, p99, p100) -- line: 52
	-- upvalues: v25 (copy)
	return v25(p97, p98, p99, p100 or {})
end

local s10 = "joinFriendsInGame"

local function v27(p101, p102, p103, p104) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s10 (copy)
	assert(type(p102) == "string", "Expected eventContext to be a string")
	assert(type(p103) == "string", "Expected placeId to be a string")
	assert(type(p104) == "table", "Expected state to be a table")

	local t14 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p103
	}
	local v150 = Immutable.JoinDictionaries(t14, p104)

	p101:setRBXEventStream(p102, s10, v150)
end

function t4.JoinFriendsInGame(p105, p106, p107, p108) -- line: 52
	-- upvalues: v27 (copy)
	return v27(p105, p106, p107, p108 or {})
end

local s11 = "shareExperienceLink"

local function v29(p109, p110, p111, p112) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s11 (copy)
	assert(type(p110) == "string", "Expected eventContext to be a string")
	assert(type(p111) == "string", "Expected placeId to be a string")
	assert(type(p112) == "table", "Expected state to be a table")

	local t15 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p111
	}
	local v160 = Immutable.JoinDictionaries(t15, p112)

	p109:setRBXEventStream(p110, s11, v160)
end

function t4.ShareExperienceLink(p113, p114, p115, p116) -- line: 52
	-- upvalues: v29 (copy)
	return v29(p113, p114, p115, p116 or {})
end

local s12 = "requestRefundClick"

local function v31(p117, p118, p119, p120) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s12 (copy)
	assert(type(p118) == "string", "Expected eventContext to be a string")
	assert(type(p119) == "string", "Expected placeId to be a string")
	assert(type(p120) == "table", "Expected state to be a table")

	local t16 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p119
	}
	local v170 = Immutable.JoinDictionaries(t16, p120)

	p117:setRBXEventStream(p118, s12, v170)
end

function t4.RequestRefundClick(p121, p122, p123, p124) -- line: 52
	-- upvalues: v31 (copy)
	return v31(p121, p122, p123, p124 or {})
end

local s13 = "mediaGalleryActivated"

local function v33(p125, p126, p127, p128) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s13 (copy)
	assert(type(p126) == "string", "Expected eventContext to be a string")
	assert(type(p127) == "string", "Expected placeId to be a string")
	assert(type(p128) == "table", "Expected state to be a table")

	local t17 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p127
	}
	local v180 = Immutable.JoinDictionaries(t17, p128)

	p125:setRBXEventStream(p126, s13, v180)
end

function t4.MediaGalleryActivated(p129, p130, p131, p132) -- line: 52
	-- upvalues: v33 (copy)
	return v33(p129, p130, p131, p132 or {})
end

local s14 = "mediaGallerySwiped"

local function v35(p133, p134, p135, p136) -- line: 16
	-- upvalues: Players (copy), Immutable (copy), s14 (copy)
	assert(type(p134) == "string", "Expected eventContext to be a string")
	assert(type(p135) == "string", "Expected placeId to be a string")
	assert(type(p136) == "table", "Expected state to be a table")

	local t18 = {
		uid = tostring(Players.LocalPlayer.UserId),
		placeId = p135
	}
	local v190 = Immutable.JoinDictionaries(t18, p136)

	p133:setRBXEventStream(p134, s14, v190)
end

function t4.MediaGallerySwiped(p137, p138, p139, p140) -- line: 52
	-- upvalues: v35 (copy)
	return v35(p137, p138, p139, p140 or {})
end

local v38

if FFlagMediaAccordionAndFullTelemetry then
	local s15 = "mediaGalleryFullViewClosed"

	local function v37(p141, p142, p143, p144) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), s15 (copy)
		assert(type(p142) == "string", "Expected eventContext to be a string")
		assert(type(p143) == "string", "Expected placeId to be a string")
		assert(type(p144) == "table", "Expected state to be a table")

		local t19 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p143
		}
		local v200 = Immutable.JoinDictionaries(t19, p144)

		p141:setRBXEventStream(p142, s15, v200)
	end

	function v38(p145, p146, p147, p148) -- line: 52
		-- upvalues: v37 (copy)
		return v37(p145, p146, p147, p148 or {})
	end
else
	v38 = nil
end

t4.MediaGalleryClosed = v38

local v41

if FFlagLuaAppDesktopMediaGalleryTelemetry then
	local s16 = "mediaGalleryMediaChanged"

	local function v40(p149, p150, p151, p152) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), s16 (copy)
		assert(type(p150) == "string", "Expected eventContext to be a string")
		assert(type(p151) == "string", "Expected placeId to be a string")
		assert(type(p152) == "table", "Expected state to be a table")

		local t20 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p151
		}
		local v210 = Immutable.JoinDictionaries(t20, p152)

		p149:setRBXEventStream(p150, s16, v210)
	end

	function v41(p153, p154, p155, p156) -- line: 52
		-- upvalues: v40 (copy)
		return v40(p153, p154, p155, p156 or {})
	end
else
	v41 = nil
end

t4.MediaGalleryMediaChanged = v41

local v44

if FFlagMediaAccordionAndFullTelemetry then
	local s17 = "mediaAccordionExpanded"

	local function v43(p157, p158, p159, p160) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), s17 (copy)
		assert(type(p158) == "string", "Expected eventContext to be a string")
		assert(type(p159) == "string", "Expected placeId to be a string")
		assert(type(p160) == "table", "Expected state to be a table")

		local t21 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p159
		}
		local v220 = Immutable.JoinDictionaries(t21, p160)

		p157:setRBXEventStream(p158, s17, v220)
	end

	function v44(p161, p162, p163, p164) -- line: 52
		-- upvalues: v43 (copy)
		return v43(p161, p162, p163, p164 or {})
	end
else
	v44 = nil
end

t4.MediaAccordionExpanded = v44

local v47

if FFlagMediaAccordionAndFullTelemetry then
	local s18 = "mediaAccordionCollapsed"

	local function v46(p165, p166, p167, p168) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), s18 (copy)
		assert(type(p166) == "string", "Expected eventContext to be a string")
		assert(type(p167) == "string", "Expected placeId to be a string")
		assert(type(p168) == "table", "Expected state to be a table")

		local t22 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p167
		}
		local v230 = Immutable.JoinDictionaries(t22, p168)

		p165:setRBXEventStream(p166, s18, v230)
	end

	function v47(p169, p170, p171, p172) -- line: 52
		-- upvalues: v46 (copy)
		return v46(p169, p170, p171, p172 or {})
	end
else
	v47 = nil
end

t4.MediaAccordionCollapsed = v47

local v50

if FFlagLuaAppEdpMediaGalleryRedesignTelemetry then
	local s19 = "mediaGalleryEnterFullscreen"

	local function v49(p173, p174, p175, p176) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), s19 (copy)
		assert(type(p174) == "string", "Expected eventContext to be a string")
		assert(type(p175) == "string", "Expected placeId to be a string")
		assert(type(p176) == "table", "Expected state to be a table")

		local t23 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p175
		}
		local v240 = Immutable.JoinDictionaries(t23, p176)

		p173:setRBXEventStream(p174, s19, v240)
	end

	function v50(p177, p178, p179, p180) -- line: 52
		-- upvalues: v49 (copy)
		return v49(p177, p178, p179, p180 or {})
	end
else
	v50 = nil
end

t4.MediaGalleryEnterFullscreen = v50

local v53

if FFlagLuaAppEdpMediaGalleryRedesignTelemetry then
	local s20 = "mediaGalleryExitFullscreen"

	local function v52(p181, p182, p183, p184) -- line: 16
		-- upvalues: Players (copy), Immutable (copy), s20 (copy)
		assert(type(p182) == "string", "Expected eventContext to be a string")
		assert(type(p183) == "string", "Expected placeId to be a string")
		assert(type(p184) == "table", "Expected state to be a table")

		local t24 = {
			uid = tostring(Players.LocalPlayer.UserId),
			placeId = p183
		}
		local v250 = Immutable.JoinDictionaries(t24, p184)

		p181:setRBXEventStream(p182, s20, v250)
	end

	function v53(p185, p186, p187, p188) -- line: 52
		-- upvalues: v52 (copy)
		return v52(p185, p186, p187, p188 or {})
	end
else
	v53 = nil
end

t4.MediaGalleryExitFullscreen = v53

return t4
