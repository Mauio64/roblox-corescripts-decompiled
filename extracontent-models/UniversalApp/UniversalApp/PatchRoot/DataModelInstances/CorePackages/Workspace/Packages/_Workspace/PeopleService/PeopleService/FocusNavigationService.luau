local GuiService = game:GetService("GuiService")
local scriptParent = script.Parent
local u3 = if not require(scriptParent.Flags).GetFFlagPeoplePageEnablePersonSignalStore() then require(scriptParent.PeopleListStore) else require(scriptParent.ServiceLocator).get("PeopleListStore")
local PeopleUtility = require(scriptParent.PeopleUtility)
local SettingsHubService = require(scriptParent.Integration.SettingsHubService)

local function createFocusNavigationService() -- line: 42
	-- upvalues: SettingsHubService (copy), GuiService (copy), u3 (ref), PeopleUtility (copy)
	local t1 = {}
	local t2 = {}
	local t3 = {}
	local t4 = {}
	local t5 = {}
	local connection = nil
	local u13 = nil
	local u14 = nil
	local u15 = false

	local function restoreScrollPosition() -- line: 78
		-- upvalues: u14 (ref), SettingsHubService (copy), u15 (ref)
		if u14 then
			local v31 = SettingsHubService.hubRef()

			if v31 and v31.PageView then
				v31.PageView.CanvasPosition = u14
				u14 = nil
				u15 = false
			end
		end
	end
	local function getFirstPersonButton() -- line: 89
		-- upvalues: t1 (copy), t3 (copy)
		local v32 = nil
		local n1 = 1e999

		for k, v in pairs(t1) do
			if k ~= -1 then
				local v36 = t3[k]

				if v36 < n1 then
					local v37 = nil
					local n2 = 1e999

					for _, v2 in pairs(v) do
						if v2.LayoutOrder and n2 > v2.LayoutOrder then
							n2 = v2.LayoutOrder
							v37 = v2
						end
					end

					if v37 then
						n1 = v36
						v32 = v37
					end
				end
			end
		end

		return v32
	end
	local function handleSelectionChange() -- line: 122
		-- upvalues: GuiService (copy), u13 (ref), t2 (copy), getFirstPersonButton (copy), u15 (ref), u14 (ref), SettingsHubService (copy), t5 (copy), t4 (copy)
		local SelectedCoreObject = GuiService.SelectedCoreObject

		if u13 and SelectedCoreObject then
			local v42 = t2[u13]
			local v43 = t2[SelectedCoreObject]

			if v42 and v42 < 0 and v43 and v43 >= 0 then
				local v44 = getFirstPersonButton()

				if v44 then
					task.defer(function() -- line: 133
						-- upvalues: GuiService (copy), v44 (copy)
						GuiService.SelectedCoreObject = v44
					end)
				end
			end
		end

		if SelectedCoreObject then
			local v45 = t2[SelectedCoreObject]

			if v45 then
				if u15 and u14 then
					if u14 then
						local v46 = SettingsHubService.hubRef()

						if v46 and v46.PageView then
							v46.PageView.CanvasPosition = u14
							u14 = nil
							u15 = false
						end
					end

					return
				end

				local v47 = t5[v45]

				if v47 then
					v47()
				else
					local v48 = t4[v45]

					if v48 then
						local v49 = SettingsHubService.hubRef()

						if v49 then
							task.defer(function() -- line: 158
								-- upvalues: v49 (copy), v48 (copy)
								v49:ScrollToFrame(v48, true)
							end)
						end
					end
				end
			end
		end

		u13 = SelectedCoreObject
	end
	local function initializeSelectionListener() -- line: 170
		-- upvalues: connection (ref), GuiService (copy), handleSelectionChange (copy)
		if not connection then
			connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(handleSelectionChange)
		end
	end
	local function disconnectSelectionListener() -- line: 177
		-- upvalues: connection (ref)
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
	local function getFocusedPersonInfo() -- line: 224
		-- upvalues: GuiService (copy), t2 (copy)
		local SelectedCoreObject = GuiService.SelectedCoreObject

		if SelectedCoreObject then
			local v61 = t2[SelectedCoreObject]
			local SelectedCoreObjectName = SelectedCoreObject.Name

			if v61 and SelectedCoreObjectName then
				return v61, SelectedCoreObjectName
			end
		end

		return nil, nil
	end
	local function findButtonForUser(n3: number, s1: string) -- line: 240
		-- upvalues: t1 (copy)
		local v65 = t1[n3]

		if not v65 then
			return nil
		end

		local v66 = v65[s1]

		if v66 then
			return v66
		end

		local v67 = nil

		for _, v in pairs(v65) do
			if not v67 or v.LayoutOrder < v67.LayoutOrder then
				v67 = v
			end
		end

		return v67
	end
	local function findNearestPerson(n4: number, t6: {[any]: any}) -- line: 262
		-- upvalues: t3 (copy)
		if #t6 == 0 then
			return nil
		end

		local v72 = t3[n4]

		if not v72 then
			return t6[1].UserId
		end

		if t6[v72] then
			return t6[v72].UserId
		end

		if v72 > 1 and t6[v72 - 1] then
			return t6[v72 - 1].UserId
		end

		return t6[1].UserId
	end

	return {
		registerButtonRow = function(n5: number, t7: {[any]: any}, n6: number) -- line: 184
			-- upvalues: t1 (copy), t3 (copy), t2 (copy), connection (ref), GuiService (copy), handleSelectionChange (copy)
			if not t1[n5] then
				t1[n5] = {}
			end

			t3[n5] = n6

			for _, v in ipairs(t7) do
				local vName = v.Name

				t1[n5][vName] = v
				t2[v] = n5
			end

			if not connection then
				connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(handleSelectionChange)
			end
		end,
		unregisterButtonRow = function(n7: number) -- line: 203
			-- upvalues: t1 (copy), t2 (copy), t3 (copy), t5 (copy), connection (ref)
			local v57 = t1[n7]

			if v57 then
				for _, v in pairs(v57) do
					t2[v] = nil
				end
			end

			t1[n7] = nil
			t3[n7] = nil
			t5[n7] = nil

			if not next(t1) and connection then
				connection:Disconnect()
				connection = nil
			end
		end,
		registerFrame = function(p1, n8: number) -- line: 55
			-- upvalues: t4 (copy)
			t4[n8] = p1
		end,
		unregisterFrame = function(n9: number) -- line: 59
			-- upvalues: t4 (copy)
			t4[n9] = nil
		end,
		registerScrollCallback = function(n10: number, p2: ((...any) -> ...any)) -- line: 63
			-- upvalues: t5 (copy)
			t5[n10] = p2
		end,
		unregisterScrollCallback = function(n11: number) -- line: 67
			-- upvalues: t5 (copy)
			t5[n11] = nil
		end,
		handlePersonRemoved = function(n12: number) -- line: 284
			-- upvalues: u3 (ref), GuiService (copy), t2 (copy), t3 (copy), t1 (copy), findButtonForUser (copy)
			local v74 = u3.people(false)
			local g78 = nil
			local v79 = nil
			local SelectedCoreObjectName = nil

			for _, v in ipairs(v74) do
				if n12 == v.UserId then
					return
				end
			end

			local SelectedCoreObject = GuiService.SelectedCoreObject

			repeat
				if g78 or SelectedCoreObject then
					if not g78 then
						v79 = t2[SelectedCoreObject]
						SelectedCoreObjectName = SelectedCoreObject.Name
					end

					if g78 or v79 and SelectedCoreObjectName then
						g78 = false

						if v79 ~= n12 or not SelectedCoreObjectName then
							return
						end

						local v81

						if #v74 == 0 then
							v81 = nil
						else
							local v82 = t3[n12]

							v81 = if v82 then if not v74[v82] then if not (v82 > 1) or not v74[v82 - 1] then v74[1].UserId else v74[v82 - 1].UserId else v74[v82].UserId else v74[1].UserId
						end

						if v81 and t1[v81] then
							local v83 = findButtonForUser(v81, SelectedCoreObjectName)

							if v83 then
								task.defer(function() -- line: 301
									-- upvalues: GuiService (copy), v83 (copy)
									GuiService.SelectedCoreObject = v83
								end)

								return
							end
						end

						for k, _ in pairs(t1) do
							if k == n12 then
								continue
							end

							local v86 = findButtonForUser(k, SelectedCoreObjectName)

							if v86 then
								task.defer(function() -- line: 313
									-- upvalues: GuiService (copy), v86 (copy)
									GuiService.SelectedCoreObject = v86
								end)

								return
							end
						end

						return
					end
				end

				v79 = nil
				SelectedCoreObjectName = nil
				g78 = true
			until not g78
		end,
		hasSelectablePlatformButton = function(n13: number?) -- line: 322
			-- upvalues: u3 (ref), PeopleUtility (copy)
			if not n13 then
				return false
			end

			local v88 = u3.getPlatformName(n13)
			local v89 = u3.getPlatformProfileId(n13)
			local v90 = v88(false)
			local v91 = v89(false)
			local v92 = v90 and (type(v90) == "string" and string.len(v90) > 0)
			local v93 = PeopleUtility.canShowPlatformProfile(v91 or "")

			return v92 and v93
		end,
		saveScrollPosition = function() -- line: 71
			-- upvalues: SettingsHubService (copy), u14 (ref)
			local v30 = SettingsHubService.hubRef()

			if v30 and v30.PageView then
				u14 = v30.PageView.CanvasPosition
			end
		end,
		setBlockingModalRestoreMode = function(b1: boolean) -- line: 340
			-- upvalues: u15 (ref)
			u15 = b1
		end,
		getFirstPersonButton = getFirstPersonButton
	}
end

return (createFocusNavigationService())
