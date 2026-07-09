local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local llama = dependencies.llama
local t = dependencies.t
local UserCarousel = require(script.Parent.UserCarousel)
local v7 = Roact.PureComponent:extend("FreezableUserCarousel")

v7.defaultProps = {
	isFrozen = false,
	analytics = {}
}
v7.validateProps = t.interface({
	isFrozen = t.optional(t.boolean)
})

function v7.init(p1) -- line: 22
	p1.isMounted = false
	p1.state = {
		peopleListFrozen = p1.props.isFrozen or false
	}

	function p1.setPeopleListFrozen(p2) -- line: 28
		-- upvalues: p1 (copy)
		if p1.isMounted then
			p1:setState({
				peopleListFrozen = p2
			})
		end
	end
end
function v7.render(p3) -- line: 37
	-- upvalues: Roact (copy), UserCarousel (copy), llama (copy)
	return Roact.createElement(UserCarousel, llama.Dictionary.join(p3.props, {
		peopleListFrozen = p3.state.peopleListFrozen,
		setPeopleListFrozen = p3.setPeopleListFrozen
	}))
end
function v7.didMount(p4) -- line: 47
	p4.isMounted = true
end
function v7.willUnmount(p5) -- line: 51
	p5.isMounted = false
end

return v7
