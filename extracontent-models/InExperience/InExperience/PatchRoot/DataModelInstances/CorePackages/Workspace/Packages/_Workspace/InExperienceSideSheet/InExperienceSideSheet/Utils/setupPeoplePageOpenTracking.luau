local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local GetSideSheetConfigStore = require(InExperienceSideSheet.Stores.GetSideSheetConfigStore)
local getDidSideSheetOpenWithPeoplePage = require(InExperienceSideSheet.Utils.getDidSideSheetOpenWithPeoplePage)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)

local v = { Players = true, peoplepage = true }

local flag = false

return function(object)
	if flag then
		return
	end

	flag = true

	local sideSheetConfigStore = GetSideSheetConfigStore(false)

	local function isPeoplePage(value: string?): boolean -- 2 equivalent calls inferred from this helper
		return v[value or ""] == true
	end

	local function updateIsPeoplePageOpen(value: string?) -- 2 equivalent calls inferred from this helper
		sideSheetConfigStore.setIsPeoplePageOpen(object:GetVisibility() and isPeoplePage(value)) -- inferred equivalent call
	end

	object.CurrentPageSignal:connect(function(value: string?)
		if not isPeoplePage(value) and getDidSideSheetOpenWithPeoplePage() then -- inferred equivalent call
			toggleSideSheet(false)
		end

		updateIsPeoplePageOpen(value) -- inferred equivalent call
	end)
	object.SettingsShowSignal:connect(function(flag2: boolean)
		if not flag2 then
			sideSheetConfigStore.setIsPeoplePageOpen(false)
			return
		end

		local currentPage

		if object.Pages then
			currentPage = object.Pages.CurrentPage
		end

		local v2

		if currentPage then
			v2 = currentPage.Page.Name
		end

		updateIsPeoplePageOpen(v2) -- inferred equivalent call
	end)
end
