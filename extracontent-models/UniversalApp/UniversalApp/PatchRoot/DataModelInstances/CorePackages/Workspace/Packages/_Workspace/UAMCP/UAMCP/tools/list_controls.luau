local utils = require(script.Parent.Parent.utils)
local btnCenter = utils.btnCenter
local isOnScreen = utils.isOnScreen

local function getControlLabel(p1) -- line: 6
	for _, child in ipairs(p1:GetChildren()) do
		if not child:IsA("TextLabel") or not child.Name:match("Label") then
			continue
		end

		local childText = child.Text

		if childText ~= "" and childText ~= "Set by Developer" then
			return childText
		end
	end

	local LabelContainer = p1:FindFirstChild("LabelContainer")

	if LabelContainer then
		local Label = LabelContainer:FindFirstChild("Label")

		if Label and Label:IsA("TextLabel") then
			return Label.Text
		end
	end

	for _, child in ipairs(p1:GetChildren()) do
		if child:IsA("Frame") and child.Name:find("Label") then
			for _, child2 in ipairs(child:GetChildren()) do
				if not child2:IsA("TextLabel") or not child2.Name:match("Label") then
					continue
				end

				local child2Text = child2.Text

				if child2Text ~= "" then
					return child2Text
				end
			end
		end
	end

	return p1.Name:gsub("Frame$", "")
end
local function isSectionHeader(p2) -- line: 37
	if p2.Name:find("Header") then
		for _, descendant in ipairs(p2:GetDescendants()) do
			if not descendant:IsA("TextLabel") then
				continue
			end

			local descendantText = descendant.Text

			if descendantText and descendantText ~= "" then
				return true, descendantText
			end
		end

		return true, nil
	end

	return false, nil
end
local function isDivider(p3) -- line: 52
	return p3.Name:find("Divider") ~= nil
end
local function collectSignals(p4) -- line: 73
	local t1 = {}

	for _, descendant in ipairs(p4:GetDescendants()) do
		local descendantName = descendant.Name

		if descendant:IsA("UIDragDetector") then
			t1.dragDetector = t1.dragDetector or descendant
		elseif descendant:IsA("GuiObject") then
			local v31 = descendantName:lower()

			if descendantName == "StepsContainer" then
				t1.stepsContainer = t1.stepsContainer or descendant
			elseif descendantName == "Bar" then
				t1.bar = t1.bar or descendant
			elseif descendantName == "Fill" then
				t1.fill = t1.fill or descendant
			elseif descendantName == "Knob" then
				t1.knob = t1.knob or descendant
			elseif v31:find("slider") then
				t1.sliderLike = t1.sliderLike or descendant
			elseif v31:find("leftbutton") then
				t1.leftBtn = t1.leftBtn or descendant
			elseif v31:find("rightbutton") then
				t1.rightBtn = t1.rightBtn or descendant
			elseif v31:find("leftarrow") then
				t1.leftArrow = t1.leftArrow or descendant
			elseif v31:find("rightarrow") then
				t1.rightArrow = t1.rightArrow or descendant
			end

			if descendant:IsA("GuiButton") and (descendantName:find("DropDown") or descendantName:find("Dropdown")) then
				t1.dropdownBtn = t1.dropdownBtn or descendant
			end
		end

		if descendant:IsA("TextLabel") then
			if descendant.Text == "chevron-large-down" then
				t1.chevronDown = t1.chevronDown or descendant
			elseif descendantName:find("Selection") and descendant.Visible then
				t1.selectionLabel = t1.selectionLabel or descendant
			elseif descendantName == "ValueText" then
				t1.valueText = t1.valueText or descendant
			end
		end
	end

	return t1
end
local function classifyControl(p5) -- line: 119
	-- upvalues: collectSignals (copy), btnCenter (copy)
	local t2 = {}
	local v34 = collectSignals(p5)

	if v34.dragDetector or (v34.stepsContainer or v34.sliderLike) then
		local s1 = ""

		if v34.stepsContainer then
			local n1 = 0
			local n2 = 0

			for _, child in ipairs(v34.stepsContainer:GetChildren()) do
				if child:IsA("ImageButton") then
					n1 += 1

					local childBackgroundColor3 = child.BackgroundColor3

					if 0.299 * childBackgroundColor3.R + 0.587 * childBackgroundColor3.G + 0.114 * childBackgroundColor3.B > 0.5 then
						n2 += 1
					end
				end
			end

			if n1 > 0 then
				s1 = ("%d/%d"):format(n2, n1)
			end
		end

		if v34.dragDetector then
			if v34.bar and v34.fill then
				local AbsoluteSizeX = v34.bar.AbsoluteSize.X
				local AbsoluteSizeX2 = v34.fill.AbsoluteSize.X

				if AbsoluteSizeX > 0 then
					s1 = ("%d%%"):format((math.round(AbsoluteSizeX2 / AbsoluteSizeX * 100)))
				end
			end

			if v34.knob then
				t2["drag knob"] = btnCenter(v34.knob)
			end
		end

		if v34.leftBtn and v34.leftBtn.Visible then
			t2["decrease (-)"] = btnCenter(v34.leftBtn)
		end

		if v34.rightBtn and v34.rightBtn.Visible then
			t2["increase (+)"] = btnCenter(v34.rightBtn)
		end

		return "slider", s1, t2
	end

	local v43 = v34.leftBtn or v34.leftArrow
	local v44 = v34.rightBtn or v34.rightArrow

	if v43 and v44 then
		local s2 = ""

		if v34.selectionLabel then
			s2 = v34.selectionLabel.Text
		end

		if s2 == "" and v34.valueText then
			s2 = v34.valueText.Text
		end

		if v43.Visible then
			t2["prev (<)"] = btnCenter(v43)
		end

		if v44.Visible then
			t2["next (>)"] = btnCenter(v44)
		end

		return "selector", s2, t2
	end

	local dropdownBtn = v34.dropdownBtn

	if not dropdownBtn and v34.chevronDown then
		local chevronDownParent = v34.chevronDown.Parent

		while chevronDownParent and chevronDownParent ~= p5 do
			if chevronDownParent:IsA("GuiButton") then
				dropdownBtn = chevronDownParent

				break
			end

			chevronDownParent = chevronDownParent.Parent
		end
	end

	if dropdownBtn then
		local s3 = ""
		local DropDownFrameTextLabel = dropdownBtn:FindFirstChild("DropDownFrameTextLabel")

		if DropDownFrameTextLabel and DropDownFrameTextLabel:IsA("TextLabel") then
			s3 = DropDownFrameTextLabel.Text
		end

		if s3 == "" then
			local TextLabel = dropdownBtn:FindFirstChildWhichIsA("TextLabel", true)

			if TextLabel and TextLabel.Name == "Text" then
				s3 = TextLabel.Text
			end
		end

		if dropdownBtn:IsA("GuiObject") then
			t2.open = btnCenter(dropdownBtn)
		end

		return "dropdown", s3, t2
	end

	if v34.knob then
		local knobParent = v34.knob.Parent

		while knobParent and knobParent ~= p5 and not knobParent:IsA("ImageButton") do
			knobParent = knobParent.Parent
		end

		if knobParent and knobParent:IsA("ImageButton") then
			local v52 = v34.knob.AbsolutePosition.X >= knobParent.AbsolutePosition.X + knobParent.AbsoluteSize.X / 2

			t2.toggle = btnCenter(knobParent)

			return "toggle", not v52 and "Off" or "On", t2
		end
	end

	for _, child in ipairs(p5:GetChildren()) do
		if not child:IsA("GuiButton") then
			continue
		end

		local TextLabel = child:FindFirstChildWhichIsA("TextLabel", true)

		if TextLabel and TextLabel.Text ~= "" then
			t2.click = btnCenter(child)

			return "button", TextLabel.Text, t2
		end
	end

	return "unknown", "", t2
end
local function collectControls(p6, p7, t3: {[any]: any}, s4: string) -- line: 245
	-- upvalues: utils (copy), isSectionHeader (copy), classifyControl (copy), getControlLabel (copy), isOnScreen (copy), collectControls (copy)
	local v60 = utils.sortChildrenByLayoutOrder(p6:GetChildren())

	for _, v in ipairs(v60) do
		if v:IsA("GuiObject") and v.Visible and v.Name:find("Divider") == nil then
			local v63, v64 = isSectionHeader(v)

			if v63 then
				if v64 then
					s4 = v64
				end
			else
				local v65, v66, v67 = classifyControl(v)

				if v65 ~= "unknown" then
					local v68 = getControlLabel(v)
					local v69 = isOnScreen(v, p7)
					local t4 = {}

					if s4 ~= "" then
						table.insert(t4, ("[%s]"):format(s4))
					end

					table.insert(t4, ("\"%s\""):format(v68))
					table.insert(t4, ("  type: %s"):format(v65))

					if v66 ~= "" then
						table.insert(t4, ("  value: %s"):format(v66))
					end

					if not v69 then
						table.insert(t4, "  *** OFF-SCREEN (scroll to see, then re-query for updated coords)")
					end

					for k, v2 in pairs(v67) do
						if v69 then
							table.insert(t4, ("  %s → click (%s)"):format(k, v2))
						else
							table.insert(t4, ("  %s → (scroll first)"):format(k))
						end
					end

					table.insert(t3, {
						layoutOrder = v.LayoutOrder,
						text = table.concat(t4, "\n")
					})
				elseif v:IsA("Frame") then
					collectControls(v, p7, t3, s4)
				end
			end
		end
	end
end

return {
	description = "List all interactive controls in a container. Auto-discovers selectors (<> arrows), sliders, toggles, dropdowns, and buttons by their intrinsic properties. Returns name, type, current value, section header, and click coordinates for each interaction. Ideal for settings pages, option panels, or any UI with multiple controls.",
	params = {
		{
			name = "path",
			desc = "DataModel path to the container holding the controls. For ESC menu settings use: game.CoreGui.RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.Page",
			required = false
		},
		{
			name = "root",
			desc = "Alias for \"path\" — the container to scan. Default: auto-detects the ESC menu settings page if open.",
			required = false
		},
		{
			name = "limit",
			required = false,
			desc = ("max results (default %d). Useful when verifying just the first few rows after scrolling."):format(utils.MAX_RESULTS)
		}
	},
	call = function(p8) -- line: 326
		-- upvalues: utils (copy), collectControls (copy)
		local v74 = p8.path or p8.root
		local v75

		if v74 then
			v75 = utils.resolveInstance(v74)

			if not v75 then
				return "ERROR: could not resolve path \"" .. tostring(v74) .. "\""
			end
		else
			v75 = utils.resolveInstance("CoreGui.RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.Page")

			if not v75 then
				return "ERROR: no path provided and ESC menu settings page not found. Open the ESC menu to the Settings tab, or provide a 'path' parameter."
			end
		end

		assert(v75, "container should be resolved by this point")

		local v76 = utils.findAncestorScrollFrame(v75)
		local t5 = {}

		collectControls(v75, v76, t5, "")

		if #t5 == 0 then
			return "No interactive controls found in " .. v75:GetFullName()
		end

		table.sort(t5, function(p9, p10) -- line: 354
			return p9.layoutOrder < p10.layoutOrder
		end)

		local v78 = tonumber(p8.limit) or utils.MAX_RESULTS
		local v79 = false

		if v78 < #t5 then
			v79 = true

			local t6 = {}

			for i = 1, v78 do
				t6[i] = t5[i]
			end

			t5 = t6
		end

		local v82 = ("Found %d control(s) in %s:\n"):format(#t5, v75:GetFullName())

		if v79 then
			v82 = ("Showing first %d control(s) (limited) in %s:\n"):format(#t5, v75:GetFullName())
		end

		local t7 = { v82 }

		for _, v in ipairs(t5) do
			table.insert(t7, v.text)
		end

		return table.concat(t7, "\n\n")
	end
}
