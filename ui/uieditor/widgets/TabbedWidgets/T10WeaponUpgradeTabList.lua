require( "ui.uieditor.widgets.TabbedWidgets.T10WeaponUpgradeTabWidget" )

local PostLoadFunc = function ( self, controller, menu )
	menu:AddButtonCallbackFunction( menu, controller, Enum.LUIButton.LUI_KEY_LB, nil, function ( element, menu, controller, model )
		if not PropertyIsTrue( self, "m_disableNavigation" ) then
			self.grid:navigateItemLeft()
		end
	end, AlwaysFalse, false )

	menu:AddButtonCallbackFunction( menu, controller, Enum.LUIButton.LUI_KEY_RB, nil, function ( element, menu, controller, model )
		if not PropertyIsTrue( self, "m_disableNavigation" ) then
			self.grid:navigateItemRight()
		end
	end, AlwaysFalse, false )

	self:setForceMouseEventDispatch( true )
end

CoD.T10WeaponUpgradeTabList = InheritFrom( LUI.UIElement )
CoD.T10WeaponUpgradeTabList.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10WeaponUpgradeTabList )
	self.id = "T10WeaponUpgradeTabList"
	self.soundSet = "none"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true
	
	self.grid = LUI.GridLayout.new( menu, controller, false, 0, 0, 14.5, 0, nil, nil, false, false, 0, 0, false, false )
	self.grid:setLeftRight( true, true, 0, 0 )
	self.grid:setTopBottom( true, true, 0, 0 )
	self.grid:setWidgetType( CoD.T10WeaponUpgradeTabWidget )
	self.grid:registerEventHandler( "menu_loaded", function ( element, event )
		local retVal = nil

		UpdateDataSource( self, element, controller )

		if not retVal then
			retVal = element:dispatchEventToChildren( event )
		end

		return retVal
	end )
	self.grid:registerEventHandler( "mouse_left_click", function ( element, event )
		local retVal = nil

		SelectItemIfPossible( self, element, controller, event )

		PlaySoundSetSound( self, "list_right" )

		if not retVal then
			retVal = element:dispatchEventToChildren( event )
		end

		return retVal
	end )
	self:addElement( self.grid )
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 1 )

				self.grid:completeAnimation()
				self.grid:setAlpha( 1 )
				self.clipFinished( self.grid, {} )
			end
		},
		Hidden = {
			DefaultClip = function ()
				self:setupElementClipCounter( 1 )

				self.grid:completeAnimation()
				self.grid:setAlpha( 0 )
				self.clipFinished( self.grid, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.grid:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
