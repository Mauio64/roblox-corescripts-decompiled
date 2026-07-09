local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local StyleProviderWithDefaultTheme = require(Parent.Style).StyleProviderWithDefaultTheme
local ok, result = pcall(function() -- line: 10
	-- upvalues: UIBlox (copy), Parent (copy)
	UIBlox.init(require(Parent.Dev.RobloxAppUIBloxConfig))
end)

if not ok then
	warn("Error initializing UIBlox", result)
end

local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider

local function renderWithStyleProvider(p1, p2) -- line: 20
	-- upvalues: Roact (copy), StyleProviderWithDefaultTheme (copy)
	return Roact.createElement(StyleProviderWithDefaultTheme, {
		theme = p1.theme
	}, p2)
end
local function renderWithCursorProvider(p3) -- line: 26
	-- upvalues: Roact (copy), SelectionCursorProvider (copy), CursorProvider (copy)
	return Roact.createElement(SelectionCursorProvider, {}, {
		NewCursorProvider = Roact.createElement(CursorProvider, {}, p3)
	})
end
local function StoryMiddleware(p4) -- line: 32
	-- upvalues: renderWithStyleProvider (copy), renderWithCursorProvider (copy), Roact (copy)
	return function(p5) -- line: 33
		-- upvalues: renderWithStyleProvider (copy), renderWithCursorProvider (copy), Roact (copy), p4 (copy)
		return renderWithStyleProvider(p5, {
			CursorProvider = renderWithCursorProvider({
				Child = Roact.createElement(p4, p5)
			})
		})
	end
end

return StoryMiddleware
