local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Cryo = require(CorePackages.Packages.Cryo)
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local EventStreamReporter = require(CorePackages.Workspace.Packages.TelemetryService).EventStreamReporter
local FFlagAXEnableInspectAndBuyVersionAnalytics = require(script.Parent.Parent.Flags.FFlagAXEnableInspectAndBuyVersionAnalytics)
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local UnifiedLoggingSurface = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local ItemTypeEnum = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemTypeEnum
local TIMED_OPTION_BY_DAYS = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Constants.TIMED_OPTION_BY_DAYS
local _ = {
	SEND_EVENT_DEFERRED = 0,
	SEND_EVENT_IMMEDIATELY = 1,
	SEND_ROBLOX_TELEMETRY_EVENT = 2
}
local t1 = {}

t1.__index = t1

function t1.__tostring() -- line: 40
	return "Service(Analytics)"
end
function t1.new(p1, p2, n1: number?) -- line: 46
	-- upvalues: t1 (copy), EventStreamReporter (copy), default (copy), Players (copy), FFlagAXEnableInspectAndBuyVersionAnalytics (copy), UnifiedEventLogEnums (copy), TIMED_OPTION_BY_DAYS (copy), ItemTypeEnum (copy), UserInputService (copy), HttpService (copy), RunService (copy), RbxAnalyticsService (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.eventStream = EventStreamReporter.new(default)
	t2.pid = tostring(game.PlaceId)
	t2.uid = tostring(Players.LocalPlayer.UserId)
	t2.feature = "inspectAndBuy"
	t2.inspecteeUid = p1
	t2.ctx = p2
	t2.version = if not FFlagAXEnableInspectAndBuyVersionAnalytics then nil else n1

	function t2.reportOpenInspectMenu() -- line: 60
		-- upvalues: t2 (copy)
		t2:report("inspectUser", {})
	end
	function t2.reportTryOnButtonClicked(p3, p4) -- line: 67
		-- upvalues: t2 (copy)
		local t3 = {
			itemType = p3,
			itemID = p4
		}

		t2:report("tryItem", t3)
	end
	function t2.reportFavoriteItem(p5, p6, p7, p8, p9, p10) -- line: 77
		-- upvalues: t2 (copy)
		local t4 = {
			itemType = p5,
			itemID = p6,
			favorite = p7,
			success = p8,
			failureReason = p9,
			favoriteCount = p10
		}

		t2:report("favoriteItem", t4)
	end
	function t2.reportPurchaseAttempt(p11, p12) -- line: 91
		-- upvalues: t2 (copy)
		local t5 = {
			itemType = p11,
			itemID = p12
		}

		t2:report("purchaseAttemptItem", t5)
	end
	function t2.reportPurchaseAttemptUnifiedEvent(p13, p14, t6: {[any]: any}) -- line: 101
		-- upvalues: t2 (copy), UnifiedEventLogEnums (copy), TIMED_OPTION_BY_DAYS (copy), ItemTypeEnum (copy)
		t2:reportUnifiedEvent({
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
			itemId = p14,
			itemType = p13,
			organicTimedOption = if t6.timedOptionDays == nil then nil else TIMED_OPTION_BY_DAYS[t6.timedOptionDays],
			assetType = if p13 ~= ItemTypeEnum.Asset then nil else t6.itemSubType,
			bundleType = if p13 ~= ItemTypeEnum.Bundle then nil else t6.itemSubType,
			organicItemPrice = t6.price or 0
		})

		local t7 = {
			itemType = p13,
			itemID = p14
		}

		t2:report("purchaseAttemptItem", t7)
	end
	function t2.reportPurchaseSuccessUnifiedEvent(p15, p16, t8: {[any]: any}) -- line: 123
		-- upvalues: t2 (copy), UnifiedEventLogEnums (copy), TIMED_OPTION_BY_DAYS (copy), ItemTypeEnum (copy)
		t2:reportUnifiedEvent({
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS,
			itemId = p16,
			itemType = p15,
			organicTimedOption = if t8.timedOptionDays == nil then nil else TIMED_OPTION_BY_DAYS[t8.timedOptionDays],
			assetType = if p15 ~= ItemTypeEnum.Asset then nil else t8.itemSubType,
			bundleType = if p15 ~= ItemTypeEnum.Bundle then nil else t8.itemSubType,
			organicItemPrice = t8.price or 0
		})

		local t9 = {
			itemType = p15,
			itemID = p16
		}

		t2:report("purchaseSuccessItem", t9)
	end
	function t2.reportPurchaseSuccess(p17, p18) -- line: 145
		-- upvalues: t2 (copy)
		local t10 = {
			itemType = p17,
			itemID = p18
		}

		t2:report("purchaseSuccessItem", t10)
	end
	function t2.reportItemDetailPageOpened(p19, p20) -- line: 159
		-- upvalues: t2 (copy)
		local t11 = {
			itemType = p19,
			itemID = p20
		}

		t2:report("itemDetailView", t11)
	end

	local function getPlatformString() -- line: 169
		-- upvalues: UserInputService (copy), HttpService (copy)
		local Platform = UserInputService:GetPlatform()
		local s1 = "Unknown"

		if Platform == Enum.Platform.Windows then
			return "Windows"
		end

		if Platform == Enum.Platform.OSX then
			return "OSX"
		end

		if Platform == Enum.Platform.IOS then
			return "IOS"
		end

		if Platform == Enum.Platform.Android then
			local UserAgent = HttpService:GetUserAgent()

			s1 = not string.find(UserAgent, "AmazonAppStore") and "Android" or "Amazon"

			if string.find(UserAgent, "OculusQuest3Store") then
				return "Quest"
			end
		else
			if Platform == Enum.Platform.XBoxOne or Platform == Enum.Platform.XBox360 then
				return "XBox"
			end

			if Platform == Enum.Platform.UWP then
				return "UWP"
			end

			if Platform == Enum.Platform.PS4 or Platform == Enum.Platform.PS3 or Platform == Enum.Platform.PS5 then
				s1 = "PlayStation"
			end
		end

		return s1
	end

	t2.platformStr = getPlatformString()

	function t2.sendCounter(p21) -- line: 202
		-- upvalues: RunService (copy), t2 (copy), RbxAnalyticsService (copy)
		if RunService:IsStudio() then
			return
		end

		local v63 = "inspectAndBuy" .. "_" .. t2.platformStr .. "_" .. p21

		RbxAnalyticsService:ReportCounter(v63)
	end

	return t2
end
function t1.report(p22, p23, p24) -- line: 214
	-- upvalues: FFlagAXEnableInspectAndBuyVersionAnalytics (copy), Cryo (copy)
	local t12 = {
		feature = "inspectAndBuy",
		event_sender_api = 2,
		pid = p22.pid,
		uid = p22.uid,
		inspecteeUid = p22.inspecteeUid,
		inspectAndBuyVersion = if not FFlagAXEnableInspectAndBuyVersionAnalytics then nil else p22.version
	}
	local v27 = Cryo.Dictionary.join(t12, p24)

	p22.eventStream:sendTelemetryEvent(p22.ctx, p23, v27)
end
function t1.reportUnifiedEvent(p25, p26) -- line: 228
	-- upvalues: UnifiedLoggingSurface (copy), Cryo (copy), UnifiedEventLogConstants (copy)
	local t13 = {
		surface = UnifiedLoggingSurface.IN_EXPERIENCE_INSPECT_BUY
	}
	local v31 = Cryo.Dictionary.join(t13, p26)

	p25.eventStream:sendTelemetryEvent(p25.ctx, UnifiedEventLogConstants.EVENT_NAME, v31)
end

return t1
