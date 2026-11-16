local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Cryo = require(CorePackages.Packages.Cryo)
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local default = LoggingProtocol.default
local TelemetryService = require(CorePackages.Workspace.Packages.TelemetryService)
local EventStreamReporter = TelemetryService.EventStreamReporter

local FFlagAXEnableInspectAndBuyVersionAnalytics = require(script.Parent.Parent.Flags.FFlagAXEnableInspectAndBuyVersionAnalytics)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums

local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local AvatarExperienceAnalytics2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local UnifiedEventLogConstants = AvatarExperienceAnalytics2.UnifiedEventLogConstants
local AvatarExperienceModel = require(CorePackages.Workspace.Packages.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local AvatarExperienceAnalytics3 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local TIMED_OPTION_BY_DAYS = AvatarExperienceAnalytics3.Constants.TIMED_OPTION_BY_DAYS
local AvatarExperienceAnalytics4 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local AXUnifiedEventFilter = AvatarExperienceAnalytics4.AXUnifiedEventFilter

local AvatarExperienceAnalytics5 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local UnifiedEventCounterAggregator = AvatarExperienceAnalytics5.UnifiedEventCounterAggregator

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXUnifiedEventCounters = AvatarExperienceFlags.FFlagAXUnifiedEventCounters

local AvatarExperienceFlags2 = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags2.FFlagAXUnifiedEventStrictPayloads

local AvatarExperienceAnalytics6 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local getMarketplaceUnifiedItemType = AvatarExperienceAnalytics6.Utils.getMarketplaceUnifiedItemType

local AvatarExperienceAnalytics7 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local getMarketplaceUnifiedAssetType = AvatarExperienceAnalytics7.Utils.getMarketplaceUnifiedAssetType

local AvatarExperienceAnalytics8 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local getMarketplaceUnifiedBundleType = AvatarExperienceAnalytics8.Utils.getMarketplaceUnifiedBundleType

local _ = { SEND_EVENT_DEFERRED = 0, SEND_EVENT_IMMEDIATELY = 1, SEND_ROBLOX_TELEMETRY_EVENT = 2 }

local Analytics = {}

Analytics.__index = Analytics
function Analytics.__tostring(): string
	return "Service(Analytics)"
end

function Analytics.new(inspecteeUid, ctx, version: number?)
	local class = {}

	setmetatable(class, Analytics)

	class.eventStream = EventStreamReporter.new(default)

	class.pid = tostring(game.PlaceId)
	class.uid = tostring(Players.LocalPlayer.UserId)
	class.feature = "inspectAndBuy"
	class.inspecteeUid = inspecteeUid
	class.ctx = ctx

	if not FFlagAXEnableInspectAndBuyVersionAnalytics then
		version = nil
	end

	class.version = version

	function class.reportOpenInspectMenu()
		class:report("inspectUser", {})
	end

	function class.reportTryOnButtonClicked(itemType, itemID)
		class:report("tryItem", { itemType = itemType, itemID = itemID })
	end

	function class.reportFavoriteItem(itemType, itemID, favorite, success, failureReason, favoriteCount)
		class:report("favoriteItem", {
			itemType = itemType,
			itemID = itemID,
			favorite = favorite,
			success = success,
			failureReason = failureReason,
			favoriteCount = favoriteCount
		})
	end

	function class.reportPurchaseAttempt(itemType, itemID)
		class:report("purchaseAttemptItem", { itemType = itemType, itemID = itemID })
	end

	function class.reportPurchaseAttemptUnifiedEvent(itemType, itemID, data)
		local v = {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
			itemId = 0,
			itemType = 0,
			organicTimedOption = 0,
			assetType = 0,
			bundleType = 0,
			organicItemPrice = 0
		}
		local itemId

		if FFlagAXUnifiedEventStrictPayloads and itemID ~= nil then
			itemId = tostring(itemID)
		else
			itemId = itemID
		end

		v.itemId = itemId
		local itemType2

		if FFlagAXUnifiedEventStrictPayloads then
			itemType2 = getMarketplaceUnifiedItemType(itemType)
		else
			itemType2 = itemType
		end

		v.itemType = itemType2
		local organicTimedOption

		if data.timedOptionDays ~= nil then
			organicTimedOption = TIMED_OPTION_BY_DAYS[data.timedOptionDays]
		end

		v.organicTimedOption = organicTimedOption
		local assetType

		if itemType == ItemTypeEnum.Asset then
			if FFlagAXUnifiedEventStrictPayloads then
				assetType = getMarketplaceUnifiedAssetType(data.itemSubType)
			else
				assetType = data.itemSubType
			end
		end

		v.assetType = assetType
		local bundleType

		if itemType == ItemTypeEnum.Bundle then
			if FFlagAXUnifiedEventStrictPayloads then
				bundleType = getMarketplaceUnifiedBundleType(data.itemSubType)
			else
				bundleType = data.itemSubType
			end
		end

		v.bundleType = bundleType

		v.organicItemPrice = data.price or 0
		class:reportUnifiedEvent(v)

		class:report("purchaseAttemptItem", { itemType = itemType, itemID = itemID })
	end

	function class.reportPurchaseSuccessUnifiedEvent(itemType, itemID, data)
		local v = {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS,
			itemId = 0,
			itemType = 0,
			organicTimedOption = 0,
			assetType = 0,
			bundleType = 0,
			organicItemPrice = 0
		}
		local itemId

		if FFlagAXUnifiedEventStrictPayloads and itemID ~= nil then
			itemId = tostring(itemID)
		else
			itemId = itemID
		end

		v.itemId = itemId
		local itemType2

		if FFlagAXUnifiedEventStrictPayloads then
			itemType2 = getMarketplaceUnifiedItemType(itemType)
		else
			itemType2 = itemType
		end

		v.itemType = itemType2
		local organicTimedOption

		if data.timedOptionDays ~= nil then
			organicTimedOption = TIMED_OPTION_BY_DAYS[data.timedOptionDays]
		end

		v.organicTimedOption = organicTimedOption
		local assetType

		if itemType == ItemTypeEnum.Asset then
			if FFlagAXUnifiedEventStrictPayloads then
				assetType = getMarketplaceUnifiedAssetType(data.itemSubType)
			else
				assetType = data.itemSubType
			end
		end

		v.assetType = assetType
		local bundleType

		if itemType == ItemTypeEnum.Bundle then
			if FFlagAXUnifiedEventStrictPayloads then
				bundleType = getMarketplaceUnifiedBundleType(data.itemSubType)
			else
				bundleType = data.itemSubType
			end
		end

		v.bundleType = bundleType

		v.organicItemPrice = data.price or 0
		class:reportUnifiedEvent(v)

		class:report("purchaseSuccessItem", { itemType = itemType, itemID = itemID })
	end

	function class.reportPurchaseSuccess(itemType, itemID)
		class:report("purchaseSuccessItem", { itemType = itemType, itemID = itemID })
	end

	function class.reportItemDetailPageOpened(itemType, itemID)
		class:report("itemDetailView", { itemType = itemType, itemID = itemID })
	end

	local function getPlatformString()
		local platform = UserInputService:GetPlatform()
		local v = "Unknown"

		if platform == Enum.Platform.Windows then
			return "Windows"
		end

		if platform == Enum.Platform.OSX then
			return "OSX"
		end

		if platform == Enum.Platform.IOS then
			return "IOS"
		end

		local v2

		if platform == Enum.Platform.Android then
			local userAgent = HttpService:GetUserAgent()
			v2 = string.find(userAgent, "AmazonAppStore") and "Amazon" or "Android"

			if string.find(userAgent, "OculusQuest3Store") then
				return "Quest"
			end

			return v2
		end

		if platform == Enum.Platform.XBoxOne or platform == Enum.Platform.XBox360 then
			return "XBox"
		end

		if platform == Enum.Platform.UWP then
			return "UWP"
		end

		return (platform == Enum.Platform.PS4 or platform == Enum.Platform.PS3 or platform == Enum.Platform.PS5)
			and "PlayStation"
			or v
	end

	class.platformStr = getPlatformString()

	function class.sendCounter(p)
		if RunService:IsStudio() then
			return
		end

		RbxAnalyticsService:ReportCounter("inspectAndBuy" .. "_" .. class.platformStr .. "_" .. p)
	end

	return class
end

function Analytics:report(p, p2)
	local v = {
		pid = self.pid,
		uid = self.uid,
		inspecteeUid = self.inspecteeUid,
		feature = "inspectAndBuy",
		event_sender_api = 2,
		inspectAndBuyVersion = 0
	}
	local inspectAndBuyVersion

	if FFlagAXEnableInspectAndBuyVersionAnalytics then
		inspectAndBuyVersion = self.version
	end

	v.inspectAndBuyVersion = inspectAndBuyVersion

	local joined = Cryo.Dictionary.join(v, p2)
	self.eventStream:sendTelemetryEvent(self.ctx, p, joined)
end

function Analytics:reportUnifiedEvent(p)
	local v = { surface = UnifiedLoggingSurface.IN_EXPERIENCE_INSPECT_BUY }

	local joined = Cryo.Dictionary.join(v, p)

	if FFlagAXUnifiedEventCounters then
		UnifiedEventCounterAggregator.record(joined, AXUnifiedEventFilter.filter(joined, {
			skipReporting = true
		}))
	end

	self.eventStream:sendTelemetryEvent(self.ctx, UnifiedEventLogConstants.EVENT_NAME, joined)
end

return Analytics
