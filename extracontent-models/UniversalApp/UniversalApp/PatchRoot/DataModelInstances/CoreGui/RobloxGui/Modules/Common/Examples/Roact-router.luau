local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local function Link(p1) -- line: 18
	-- upvalues: Roact (copy)
	local text = p1.text
	local onClick = p1.onClick

	local function setTarget() -- line: 22
		-- upvalues: onClick (copy), p1 (copy)
		onClick(p1.target)
	end

	return Roact.createElement("TextButton", {
		Size = UDim2.new(0, 100, 0, 30),
		Text = text,
		[Roact.Event.Activated] = setTarget
	})
end

local u8 = RoactRodux.connect(function(p2, _) -- line: 34
	return {
		location = p2.location
	}
end, function(p4) -- line: 38
	return {
		onClick = function(p5) -- line: 40
			-- upvalues: p4 (copy)
			p4({
				type = "Navigate",
				location = p5
			})
		end
	}
end)(Link)

local function BackButton(p6) -- line: 54
	-- upvalues: Roact (copy)
	local onClick = p6.onClick
	local enabled = p6.enabled

	return Roact.createElement("TextButton", {
		Size = UDim2.new(0, 30, 0, 30),
		Text = "<",
		AutoButtonColor = enabled,
		BackgroundColor3 = enabled and Color3.new(0.8, 0.8, 0.8) or Color3.new(0.5, 0.5, 0.5),
		[Roact.Event.Activated] = onClick
	})
end

local u10 = RoactRodux.connect(function(p7, _) -- line: 68
	return {
		enabled = #p7.history > 0
	}
end, function(p9) -- line: 72
	return {
		onClick = function() -- line: 74
			-- upvalues: p9 (copy)
			p9({
				type = "Back"
			})
		end
	}
end)(BackButton)

local function Route(p10) -- line: 88
	-- upvalues: Roact (copy)
	local current = p10.current
	local match = p10.match
	local component = p10.component

	if current == match then
		return Roact.createElement(component)
	end

	return nil
end

local u12 = RoactRodux.connect(function(p11, _) -- line: 102
	return {
		current = p11.current
	}
end, nil)(Route)

local function NavBar() -- line: 112
	-- upvalues: Roact (copy), u10 (ref), u8 (ref)
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.new(1, 1, 1)
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal
		}),
		Back = Roact.createElement(u10),
		GoHome = Roact.createElement(u8, {
			text = "Go to Home",
			target = "home"
		}),
		GoAbout = Roact.createElement(u8, {
			text = "Go to About",
			target = "about"
		}),
		GoContact = Roact.createElement(u8, {
			text = "Go to Contact",
			target = "contact"
		})
	})
end
local function Home() -- line: 142
	-- upvalues: Roact (copy)
	return Roact.createElement("TextLabel", {
		Text = "Home",
		TextSize = 30,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0.5, 0.3, 0.7),
		TextColor3 = Color3.new(0.95, 0.95, 0.95)
	})
end
local function About() -- line: 153
	-- upvalues: Roact (copy)
	return Roact.createElement("TextLabel", {
		Text = "About",
		TextSize = 30,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0.5, 0.6, 0.2),
		TextColor3 = Color3.new(0.95, 0.95, 0.95)
	})
end
local function Contact() -- line: 164
	-- upvalues: Roact (copy)
	return Roact.createElement("TextLabel", {
		Text = "Contact",
		TextSize = 30,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0.8, 0.3, 0.4),
		TextColor3 = Color3.new(0.95, 0.95, 0.95)
	})
end

local v17 = Roact.Component:extend("App")

function v17.render(_) -- line: 179
	-- upvalues: Roact (copy), u12 (ref), Home (copy), About (copy), Contact (copy), NavBar (copy)
	return Roact.createElement("ScreenGui", {}, {
		Body = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 600, 0, 400),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			Home = Roact.createElement(u12, {
				match = "home",
				component = Home
			}),
			About = Roact.createElement(u12, {
				match = "about",
				component = About
			}),
			Contact = Roact.createElement(u12, {
				match = "contact",
				component = Contact
			}),
			NavBar = Roact.createElement(NavBar)
		})
	})
end

local function reducer(p14, p15) -- line: 217
	-- upvalues: Cryo (copy)
	local v41 = p14 or {
		current = "home",
		history = {}
	}

	if p15.type == "Navigate" then
		if v41.current ~= p15.location then
			return {
				current = p15.location,
				history = Cryo.List.join(v41.history, { v41.current })
			}
		end
	elseif p15.type == "Back" then
		local v42 = #v41.history

		if v42 == 0 then
			return v41
		end

		return {
			current = v41.history[v42],
			history = Cryo.List.removeIndex(v41.history, v42)
		}
	end

	return v41
end

return function() -- line: 246
	-- upvalues: Rodux (copy), reducer (copy), Roact (copy), RoactRodux (copy), v17 (copy), CoreGui (copy)
	local v43 = Rodux.Store.new(reducer)
	local v44 = Roact.createElement(RoactRodux.StoreProvider, {
		store = v43
	}, {
		App = Roact.createElement(v17)
	})

	Roact.mount(v44, CoreGui, "Roact-router")
end
