local MusicTestingUtils = script:FindFirstAncestor("MusicTestingUtils")

require(MusicTestingUtils.Parent.React)

local Cryo = require(MusicTestingUtils.Parent.Cryo)
local ContextProviders = require(MusicTestingUtils.ContextProviders)

local function createReactTestingLibrary() -- line: 8
	-- upvalues: MusicTestingUtils (copy), Cryo (copy), ContextProviders (copy)
	local ReactTestingLibrary = require(MusicTestingUtils.Parent.ReactTestingLibrary)
	local FoundationTestingLibrary = require(MusicTestingUtils.Parent.FoundationTestingLibrary)
	local render = ReactTestingLibrary.render

	local function customRender(p1, t1: {[any]: any}?) -- line: 18
		-- upvalues: render (copy), Cryo (copy), ContextProviders (copy), ReactTestingLibrary (copy), FoundationTestingLibrary (copy)
		return render(p1, Cryo.Dictionary.join({
			wrapper = ContextProviders,
			queries = Cryo.Dictionary.join(ReactTestingLibrary.queries, FoundationTestingLibrary.Queries)
		}, t1 or {}))
	end

	return {
		render = customRender,
		act = ReactTestingLibrary.act,
		container = ReactTestingLibrary.container,
		document = ReactTestingLibrary.document,
		fireEvent = ReactTestingLibrary.fireEvent,
		screen = ReactTestingLibrary.screen,
		waitFor = ReactTestingLibrary.waitFor
	}
end

return createReactTestingLibrary
