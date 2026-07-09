local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetOwnedItemIdsBySubtype = require(Modules.AvatarExperience.AvatarEditor.Actions.SetOwnedItemIdsBySubtype)
local SetPageFinished = require(Modules.AvatarExperience.AvatarEditor.Actions.SetPageFinished)
local SetAssetInfoFromInventoryFetch = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAssetInfoFromInventoryFetch)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants3 = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function checkAssetExists(p1, p2) -- line: 30
	local v24 = p1.AvatarExperience.Common.AssetInfos[p2]

	if v24 and v24.receivedFromInventoryFetch then
		return true
	end

	return false
end
local function v19(p3, p4, p5, p6, p7, p8) -- line: 40
	-- upvalues: Utils (copy), SetAssetInfoFromInventoryFetch (copy), SetPageFinished (copy), SetOwnedItemIdsBySubtype (copy), Constants (copy)
	local v31 = p4:getState()
	local CurrentPage = p5:GetCurrentPage()
	local t1 = {}
	local t2 = {}

	for _, v36 in (Utils.tableToCamelCaseKeys(CurrentPage)) do
		local str = tostring(v36.assetId)

		t2[#t2 + 1] = str

		local v38 = v31.AvatarExperience.Common.AssetInfos[str]

		if not v38 or not v38.receivedFromInventoryFetch then
			t1[#t1 + 1] = v36
		end
	end

	if #t1 > 0 then
		p4:dispatch(SetAssetInfoFromInventoryFetch(t1))
	end

	p4:dispatch(SetPageFinished(p3, p5.IsFinished))
	p6:storePageObject(p3, p5)
	p4:dispatch(SetOwnedItemIdsBySubtype(p8 or p3, t2))

	local ReachedLastPage = nil

	if p5.IsFinished then
		ReachedLastPage = Constants.ReachedLastPage
	end

	p7(ReachedLastPage)
end
local function advancePage(p9, p10, p11, p12, p13, p14, p15) -- line: 72
	-- upvalues: v19 (copy), Logging (copy)
	local ok, result = pcall(function() -- line: 73
		-- upvalues: p11 (copy)
		p11:AdvanceToNextPageAsync()
	end)

	if ok then
		v19(p9, p10, p11, p12, p13, p15)

		return
	end

	Logging.warn("GetUserInventory failure: " .. result)
	p14()
end
local function fetchInitialPage(p16, p17, p18, p19, p20, p21, p22, p23) -- line: 85
	-- upvalues: Utils (copy), v19 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants3 (copy), Logging (copy)
	local ok, result = pcall(function() -- line: 95
		-- upvalues: p17 (copy), Utils (copy), p20 (copy)
		local t3 = {}

		for _, v64 in p17 do
			table.insert(t3, (Utils.AssetTypeIdStringToEnumValue(v64)))
		end

		if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			return p20:GetInventoryAsync(t3)
		end

		return p20:GetInventory(t3)
	end)

	if ok then
		v19(p16, p18, result, p19, p21, p23)

		return
	end

	if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
		reportAvatarEventCounterNoAnalyticsArgument(Constants3.Counter.AvatarEditorServiceErrors.GetInventory)
	end

	Logging.warn("GetUserInventory failure: " .. result)
	p22()
end

return function(p24, p25, p26) -- line: 121
	-- upvalues: ArgCheck (copy), Utils2 (copy), Promise (copy), PerformFetch (copy), Constants2 (copy), Constants (copy), fetchInitialPage (copy), advancePage (copy)
	ArgCheck.isType(p24, "table", "GetUserInventory thunk expects categoryInfo to be a table")

	return function(p27, p28) -- line: 124
		-- upvalues: Utils2 (copy), p24 (copy), Promise (copy), p25 (copy), PerformFetch (copy), Constants2 (copy), Constants (copy), fetchInitialPage (copy), p26 (copy), advancePage (copy)
		local pageObjectManager = p28.pageObjectManager
		local avatarEditorService = p28.avatarEditorService
		local v69, v70 = Utils2.getSearchUuidAndAssetTypes(p24, p27:getState().AvatarExperience.AvatarEditor.Categories.subButton)

		if not v69 then
			return Promise.resolve("No SearchUuid")
		end

		local u71 = p25 or v69

		return PerformFetch.Single(Constants2.UserInventoryKey .. u71, function(p29) -- line: 142
			-- upvalues: pageObjectManager (copy), u71 (ref), Promise (copy), Constants (copy), fetchInitialPage (copy), v70 (copy), avatarEditorService (copy), p26 (copy), advancePage (copy)
			local v73 = pageObjectManager:getPageObject(u71)

			if v73 and v73.IsFinished then
				return Promise.resolve(Constants.ReachedLastPage)
			end

			return Promise.new(function(resolve, reject) -- line: 149
				-- upvalues: v73 (copy), fetchInitialPage (copy), u71 (ref), v70 (copy), p29 (copy), pageObjectManager (copy), avatarEditorService (copy), p26 (copy), advancePage (copy)
				if v73 == nil then
					fetchInitialPage(u71, v70, p29, pageObjectManager, avatarEditorService, resolve, reject, p26)

					return
				end

				advancePage(u71, p29, v73, pageObjectManager, resolve, reject, p26)
			end)
		end)(p27)
	end
end
