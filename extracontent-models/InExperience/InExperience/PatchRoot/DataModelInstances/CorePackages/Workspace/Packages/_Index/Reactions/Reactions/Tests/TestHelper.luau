local Reactions = script:FindFirstAncestor("Reactions")
local parent = Reactions.Parent

local Foundation = require(parent.Foundation)
local FoundationImages = require(parent.FoundationImages)
local React = require(parent.React)

local Constants = require(Reactions.Constants)
local ReactRoblox = require(parent.Dev.ReactRoblox)
local ReactTestingLibrary = require(parent.Dev.ReactTestingLibrary)
local Rhodium = require(parent.Dev.Rhodium)

local FoundationProvider = Foundation.FoundationProvider

local TestHelper = {}

function TestHelper.withFoundation(p, overlayGui, preferences)
	return React.createElement(
		FoundationProvider,
		{ theme = Foundation.Enums.Theme.Dark, overlayGui = overlayGui, preferences = preferences },
		p
	)
end

function TestHelper.render(subject, container, p)
	local v = nil
	ReactRoblox.act(function()
		v = ReactTestingLibrary.render(
			TestHelper.withFoundation({ Subject = subject }, container, p),
			container and { container = container } or nil
		)
	end)
	return v
end

local function TokenProbe(p): nil
	local v = Foundation.Hooks.useTokens()
	p.onTokens(v)
	return nil
end

function TestHelper.getTokens()
	local tokens = nil
	TestHelper.runWhileMounted(TestHelper.withFoundation({
		Probe = React.createElement(TokenProbe, {
			onTokens = function(p)
				tokens = p
			end
		})
	}), function() end)

	assert(tokens ~= nil, "expected FoundationProvider to provide tokens")
	return tokens
end

function TestHelper.createOverlayGui()
	local testOverlay = Instance.new("ScreenGui")
	testOverlay.Name = "TestOverlay"
	testOverlay.Parent = game:GetService("CoreGui")
	return testOverlay
end

function TestHelper.getExpectedReactionSprite(p: string)
	local reactionIconMapping = Constants.ReactionIconMappings[p]
	local image = FoundationImages.Images[reactionIconMapping]
	return { Image = image.Image, ImageRectOffset = image.ImageRectOffset }
end

function TestHelper.getReactionSprite(p)
	return { Image = p.Image, ImageRectOffset = p.ImageRectOffset }
end

function TestHelper.runWhileMounted(p, callback)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Parent = game:GetService("CoreGui")

	local root = ReactRoblox.createRoot(screenGui)

	ReactRoblox.act(function()
		root:render(p)
	end)

	local success, result = pcall(callback, screenGui)

	root:unmount()
	screenGui:Destroy()

	if not success then
		error(result)
	end
end

function TestHelper.findFirstInstance(folder, items)
	for _, descendant in folder:GetDescendants() do
		local flag = true

		for k, item in items do
			local v = k
			local success, result = pcall(function()
				return descendant[v]
			end)

			if not success or result ~= item then
				flag = false
				break
			end
		end

		if flag then
			return descendant
		end
	end

	return nil
end

function TestHelper.countChildren(p, name: string, callback)
	local firstInstance = TestHelper.findFirstInstance(p, { Name = name })

	if not firstInstance then
		return 0
	end

	local count = 0

	for _, child in firstInstance:GetChildren() do
		if callback == nil or callback(child) then
			count += 1
		end
	end

	return count
end

function TestHelper.clickInstance(p)
	Rhodium.Element.new(p):click()
	task.wait()
end

return TestHelper
