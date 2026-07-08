local color3 = Color3.new(0.10588235294117647, 0.9882352941176471, 0.4196078431372549)
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local v7 = GuiService:IsTenFootInterface()

local function CreateModule() -- line: 30
	-- upvalues: Create (copy), RobloxGui (copy), color3 (copy), Players (copy)
	local t1 = {
		Container = nil
	}
	local t2 = {}
	local BindableEvent = Instance.new("BindableEvent")
	local BindableEvent2 = Instance.new("BindableEvent")

	local function createContainer() -- line: 39
		-- upvalues: t1 (copy), Create (copy), RobloxGui (copy)
		if not t1.Container then
			t1.Container = Create("ImageButton")({
				Name = "TopRightContainer",
				AutoButtonColor = false,
				Image = "",
				Active = false,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 350, 0, 100),
				Position = UDim2.new(1, -415, 0, 10),
				Parent = RobloxGui
			})
		end
	end

	function removeFromDisplayStack(p1) -- line: 55
		-- upvalues: t2 (copy), BindableEvent (copy)
		local v22 = nil

		for i = 1, #t2 do
			if p1 == t2[i] then
				v22 = i + 1

				break
			end
		end

		for i = v22, #t2 do
			local v25 = t2[i]

			v25.Position = UDim2.new(v25.Position.X.Scale, v25.Position.X.Offset, v25.Position.Y.Scale, p1.AbsolutePosition.Y)
			p1 = v25
		end

		BindableEvent:Fire()
	end
	function addBackToDisplayStack(p2) -- line: 75
		-- upvalues: t2 (copy), BindableEvent (copy)
		local n1 = 0

		for i = 1, #t2 do
			if p2 == t2[i] then
				n1 = i + 1

				break
			end
		end

		for i = n1, #t2 do
			local v30 = t2[i]
			local v31 = p2.AbsolutePosition.Y + p2.AbsoluteSize.Y + 4

			v30.Position = UDim2.new(v30.Position.X.Scale, v30.Position.X.Offset, v30.Position.Y.Scale, v31)
			p2 = v30
		end

		BindableEvent:Fire()
	end
	function addToDisplayStack(p3) -- line: 96
		-- upvalues: t2 (copy), createContainer (copy), t1 (copy), BindableEvent (copy)
		local v33 = nil

		if #t2 > 0 then
			v33 = t2[#t2]
		end

		t2[#t2 + 1] = p3

		local n2 = 0

		if v33 then
			n2 = v33.AbsolutePosition.Y + v33.AbsoluteSize.Y + 4
		end

		p3.Position = UDim2.new(p3.Position.X.Scale, p3.Position.X.Offset, p3.Position.Y.Scale, n2)
		createContainer()
		p3.Parent = t1.Container
		p3.Changed:connect(function(p4) -- line: 114
			-- upvalues: p3 (copy)
			if p4 == "Visible" then
				if not p3.Visible then
					removeFromDisplayStack(p3)

					return
				end

				addBackToDisplayStack(p3)
			end
		end)
		BindableEvent:Fire()
	end
	function t1.CreateHealthBar(_) -- line: 126
		-- upvalues: t1 (copy), Create (copy), color3 (copy), createContainer (copy), BindableEvent2 (copy)
		t1.HealthContainer = Create("Frame")({
			Name = "HealthContainer",
			BorderSizePixel = 0,
			BackgroundTransparency = 0.5,
			Size = UDim2.new(1, -86, 0, 50),
			Position = UDim2.new(0, 92, 0, 0),
			BackgroundColor3 = Color3.new(0, 0, 0)
		})

		local v36 = Create("Frame")({
			Name = "HealthFillHolder",
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -10, 1, -10),
			Position = UDim2.new(0, 5, 0, 5),
			BackgroundColor3 = Color3.new(1, 1, 1),
			Parent = t1.HealthContainer
		})
		local v37 = Create("Frame")({
			Name = "HealthFill",
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = color3,
			Parent = v36
		})

		Create("TextLabel")({
			Name = "HealthText",
			BackgroundTransparency = 0.5,
			Text = "Health",
			BorderSizePixel = 0,
			Size = UDim2.new(0, 98, 0, 50),
			Position = UDim2.new(0, -100, 0, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans,
			FontSize = Enum.FontSize.Size36,
			TextColor3 = Color3.new(1, 1, 1),
			Parent = t1.HealthContainer
		})

		local v38 = Create("TextLabel")({
			Visible = false
		})
		local v39 = Create("TextLabel")({
			Visible = false
		})

		addToDisplayStack(t1.HealthContainer)
		createContainer()
		t1.HealthContainer.Changed:connect(function() -- line: 181
			-- upvalues: BindableEvent2 (copy)
			BindableEvent2:Fire()
		end)

		return t1.Container, v38, t1.HealthContainer, v37, v39
	end
	function t1.CreateAccountType(_, p7) -- line: 188
		-- upvalues: t1 (copy), Create (copy), RobloxGui (copy)
		t1.AccountTypeContainer = Create("Frame")({
			Name = "AccountTypeContainer",
			BorderSizePixel = 0,
			BackgroundTransparency = 0.5,
			Size = UDim2.new(0, 50, 0, 50),
			Position = UDim2.new(1, -55, 0, 10),
			BackgroundColor3 = Color3.new(0, 0, 0),
			Parent = RobloxGui
		})
		Create("TextLabel")({
			Name = "AccountTypeText",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans,
			FontSize = Enum.FontSize.Size36,
			Text = p7,
			TextColor3 = Color3.new(1, 1, 1),
			Parent = t1.AccountTypeContainer,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	end
	function t1.SetupTopStat(_) -- line: 216
		-- upvalues: Create (copy), Players (copy)
		local u43 = true
		local u44 = nil
		local u45 = nil
		local u46 = nil
		local u47 = nil
		local u48 = nil

		local function makeTenFootInterfaceStat() -- line: 224
			-- upvalues: u48 (ref), Create (copy)
			if u48 then
				return
			end

			u48 = Create("Frame")({
				Name = "OneStatFrame",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 36),
				Position = UDim2.new(0, 0, 0, 0)
			})

			local v56 = Create("TextLabel")({
				Name = "StatName",
				BackgroundTransparency = 1,
				TextStrokeTransparency = 0,
				Text = " StatName:",
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Size = UDim2.new(0.5, 0, 0, 36),
				Font = Enum.Font.SourceSans,
				FontSize = Enum.FontSize.Size36,
				TextStrokeColor3 = Color3.new(0.40784313725490196, 0.40784313725490196, 0.40784313725490196),
				TextColor3 = Color3.new(1, 1, 1),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = u48
			}):clone()

			v56.Position = UDim2.new(0.5, 0, 0, 0)
			v56.Name = "StatValue"
			v56.Text = "123,643,231"
			v56.TextXAlignment = Enum.TextXAlignment.Right
			v56.Parent = u48
			addToDisplayStack(u48)
		end

		local updateTenFootStat = nil

		local function setDisplayedStat(p9) -- line: 261
			-- upvalues: u45 (ref), u46 (ref), u44 (ref), makeTenFootInterfaceStat (copy), updateTenFootStat (ref)
			if u45 then
				u45:disconnect()
				u45 = nil
			end

			if u46 then
				u46:disconnect()
				u46 = nil
			end

			u44 = p9

			if u44 then
				makeTenFootInterfaceStat()
				updateTenFootStat(u44)
				u46 = u44.AncestryChanged:connect(function() -- line: 276
					-- upvalues: updateTenFootStat (ref), u44 (ref)
					updateTenFootStat(u44, "Parent")
				end)
				u45 = u44.Changed:connect(function(p10) -- line: 277
					-- upvalues: updateTenFootStat (ref), u44 (ref)
					updateTenFootStat(u44, p10)
				end)
			end
		end

		function updateTenFootStat(p11, p12) -- line: 281
			-- upvalues: u48 (ref), setDisplayedStat (copy), u43 (ref)
			if p12 and p12 == "Parent" then
				u48.StatName.Text = ""
				u48.StatValue.Text = ""
				setDisplayedStat(nil)
				tenFootInterfaceChanged()

				return
			end

			if u43 then
				u48.StatName.Text = " " .. tostring(p11.Name) .. ":"
				u48.StatValue.Text = tostring(p11.Value)

				return
			end

			u48.StatName.Text = ""
			u48.StatValue.Text = ""
		end

		local function isValidStat(p13) -- line: 299
			return p13:IsA("StringValue") or (p13:IsA("IntValue") or (p13:IsA("BoolValue") or (p13:IsA("NumberValue") or (p13:IsA("DoubleConstrainedValue") or p13:IsA("IntConstrainedValue")))))
		end
		local function tenFootInterfaceNewStat(p14) -- line: 304
			-- upvalues: u44 (ref), isValidStat (copy), setDisplayedStat (copy)
			if not u44 and isValidStat(p14) then
				setDisplayedStat(p14)
			end
		end

		local LocalPlayer = Players.LocalPlayer

		while not LocalPlayer do
			Players.PlayerAdded:wait()
			LocalPlayer = Players.LocalPlayer
		end

		function tenFootInterfaceChanged() -- line: 316
			-- upvalues: LocalPlayer (ref), u44 (ref), isValidStat (copy), setDisplayedStat (copy), u47 (ref)
			local leaderstats = LocalPlayer:FindFirstChild("leaderstats")

			if leaderstats then
				local children = leaderstats:GetChildren()

				for i = 1, #children do
					local v65 = children[i]

					if not u44 and isValidStat(v65) then
						setDisplayedStat(v65)
					end
				end

				if u47 then
					u47:disconnect()
				end

				u47 = leaderstats.ChildAdded:connect(function(p15) -- line: 324
					-- upvalues: u44 (ref), isValidStat (copy), setDisplayedStat (copy)
					if not u44 and isValidStat(p15) then
						setDisplayedStat(p15)
					end
				end)
			end
		end

		if LocalPlayer:FindFirstChild("leaderstats") then
			tenFootInterfaceChanged()
		else
			LocalPlayer.ChildAdded:connect(tenFootInterfaceChanged)
		end

		return {
			SetTopStatEnabled = function(_, p17) -- line: 341
				-- upvalues: u43 (ref), u44 (ref), updateTenFootStat (ref)
				u43 = p17

				if u44 then
					updateTenFootStat(u44, "")
				end
			end
		}
	end

	return t1
end

local t3 = {}
local v10 = CreateModule()

function t3.IsEnabled(_) -- line: 361
	-- upvalues: v7 (copy)
	return v7
end
function t3.CreateHealthBar(_) -- line: 365
	-- upvalues: v10 (copy)
	return v10:CreateHealthBar()
end
function t3.CreateAccountType(_, p21) -- line: 369
	-- upvalues: v10 (copy)
	return v10:CreateAccountType(p21)
end
function t3.SetupTopStat(_) -- line: 373
	-- upvalues: v10 (copy)
	return v10:SetupTopStat()
end

return t3
