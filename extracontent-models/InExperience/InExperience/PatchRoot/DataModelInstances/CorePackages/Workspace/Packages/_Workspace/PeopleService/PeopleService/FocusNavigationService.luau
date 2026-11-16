local GuiService = game:GetService("GuiService")

local parent = script.Parent

local Flags = require(parent.Flags)
local v

if Flags.GetFFlagPeoplePageEnablePersonSignalStore() then
	local ServiceLocator = require(parent.ServiceLocator)
	v = ServiceLocator.get("PeopleListStore")
else
	v = require(parent.PeopleListStore)
end

local PeopleUtility = require(parent.PeopleUtility)
local SettingsHubService = require(parent.Integration.SettingsHubService)

local function createFocusNavigationService()
	local v2 = {}
	local v3 = {}
	local v4 = {}
	local v5 = {}
	local v6 = {}
	local selectedCoreObjectChangedConnection = nil
	local v7 = nil

	local canvasPosition = nil
	local v8 = false

	local function restoreScrollPosition() -- 1 equivalent call inferred from this helper
		if canvasPosition then
			local hubRef = SettingsHubService.hubRef()

			if hubRef and hubRef.PageView then
				hubRef.PageView.CanvasPosition = canvasPosition
				canvasPosition = nil
				v8 = false
			end
		end
	end

	local function getFirstPersonButton()
		local v9 = 1e999
		local firstPersonButton = nil

		for k, v10 in pairs(v2) do
			if k == -1 then
				continue
			end

			local v11 = v4[k]

			if not (v11 < v9) then
				continue
			end

			local v12 = 1e999
			local v13 = nil

			for _, v14 in pairs(v10) do
				if not (v14.LayoutOrder and v14.LayoutOrder < v12) then
					continue
				end

				v12 = v14.LayoutOrder
				v13 = v14
			end

			if not v13 then
				continue
			end

			firstPersonButton = v13
			v9 = v11
		end

		return firstPersonButton
	end

	local function handleSelectionChange()
		local selectedCoreObject = GuiService.SelectedCoreObject

		if v7 and selectedCoreObject then
			local v9 = v3[v7]
			local v10 = v3[selectedCoreObject]

			local selectedCoreObject2 = v9 and v9 < 0 and v10 and v10 >= 0 and getFirstPersonButton()

			if selectedCoreObject2 then
				task.defer(function()
					GuiService.SelectedCoreObject = selectedCoreObject2
				end)
			end
		end

		local v9 = selectedCoreObject and v3[selectedCoreObject]

		if v9 then
			if v8 and canvasPosition then
				restoreScrollPosition() -- inferred equivalent call
				return
			else
				local v10 = v6[v9]

				if v10 then
					v10()
				else
					local v11 = v5[v9]

					local v12 = v11 and SettingsHubService.hubRef()

					if v12 then
						task.defer(function()
							v12:ScrollToFrame(v11, true)
						end)
					end
				end
			end
		end

		v7 = selectedCoreObject
	end

	local function initializeSelectionListener() -- 1 equivalent call inferred from this helper
		if not selectedCoreObjectChangedConnection then
			selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(handleSelectionChange)
		end
	end

	local function disconnectSelectionListener() -- 1 equivalent call inferred from this helper
		if selectedCoreObjectChangedConnection then
			selectedCoreObjectChangedConnection:Disconnect()
			selectedCoreObjectChangedConnection = nil
		end
	end

	local function getFocusedPersonInfo()
		local selectedCoreObject = GuiService.SelectedCoreObject

		if not selectedCoreObject then
			return nil, nil
		end

		local v9 = v3[selectedCoreObject]
		local name = selectedCoreObject.Name

		if v9 and name then
			return v9, name
		end

		return nil, nil
	end

	local function findButtonForUser(p: number, name: string)
		local v9 = v2[p]

		if not v9 then
			return nil
		end

		local v10 = v9[name]

		if v10 then
			return v10
		end

		local v11 = nil

		for _, v12 in pairs(v9) do
			if not v11 or v12.LayoutOrder < v11.LayoutOrder then
				v11 = v12
			end
		end

		return v11
	end

	local function findNearestPerson(p: number, list) -- 1 equivalent call inferred from this helper
		if #list == 0 then
			return nil
		end

		local v9 = v4[p]

		if not v9 then
			return list[1].UserId
		end

		if list[v9] then
			return list[v9].UserId
		end

		if v9 > 1 and list[v9 - 1] then
			return list[v9 - 1].UserId
		end

		return list[1].UserId
	end

	return {
		registerButtonRow = function(p: number, list, p2: number)
			if not v2[p] then
				v2[p] = {}
			end

			v4[p] = p2

			for _, item in ipairs(list) do
				local name = item.Name

				v2[p][name] = item
				v3[item] = p
			end

			initializeSelectionListener() -- inferred equivalent call
		end,
		unregisterButtonRow = function(p: number)
			local v9 = v2[p]

			if v9 then
				for _, v10 in pairs(v9) do
					v3[v10] = nil
				end
			end

			v2[p] = nil
			v4[p] = nil

			v6[p] = nil

			if not next(v2) then
				disconnectSelectionListener() -- inferred equivalent call
			end
		end,
		registerFrame = function(p, p2: number)
			v5[p2] = p
		end,
		unregisterFrame = function(p: number)
			v5[p] = nil
		end,
		registerScrollCallback = function(p: number, callback)
			v6[p] = callback
		end,
		unregisterScrollCallback = function(p: number)
			v6[p] = nil
		end,
		handlePersonRemoved = function(p: number)
			local people = v.people(false)

			for _, person in ipairs(people) do
				if person.UserId == p then
					return
				end
			end

			local selectedCoreObject = GuiService.SelectedCoreObject
			local v9, name

			if selectedCoreObject then
				v9 = v3[selectedCoreObject]
				name = selectedCoreObject.Name

				if not (v9 and name) then
					v9 = nil
					name = nil
				end
			end

			if v9 ~= p or not name then
				return
			end

			local nearestPerson = findNearestPerson(p, people) -- inferred equivalent call
			local selectedCoreObject2 = nearestPerson and v2[nearestPerson] and findButtonForUser(nearestPerson, name)

			if selectedCoreObject2 then
				task.defer(function()
					GuiService.SelectedCoreObject = selectedCoreObject2
				end)
				return
			end

			for k, _ in pairs(v2) do
				if k == p then
					continue
				end

				local buttonForUser = findButtonForUser(k, name)

				if buttonForUser then
					task.defer(function()
						GuiService.SelectedCoreObject = buttonForUser
					end)
					break
				end
			end
		end,
		hasSelectablePlatformButton = function(p: number?)
			if not p then
				return false
			end

			local platformName = v.getPlatformName(p)
			local platformProfileId = v.getPlatformProfileId(p)

			local v9 = platformName(false)
			local v10 = platformProfileId(false)

			if v9 then
				if type(v9) == "string" then
					v9 = string.len(v9) > 0
				else
					v9 = false
				end
			end

			local canShowPlatformProfile = PeopleUtility.canShowPlatformProfile(v10 or "")

			return v9 and canShowPlatformProfile
		end,
		saveScrollPosition = function()
			local hubRef = SettingsHubService.hubRef()

			if hubRef and hubRef.PageView then
				canvasPosition = hubRef.PageView.CanvasPosition
			end
		end,
		setBlockingModalRestoreMode = function(flag: boolean)
			v8 = flag
		end,
		getFirstPersonButton = getFirstPersonButton
	}
end

return createFocusNavigationService()
