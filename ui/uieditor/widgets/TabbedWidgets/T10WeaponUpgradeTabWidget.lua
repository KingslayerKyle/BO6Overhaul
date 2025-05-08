local PostLoadFunc = function ( self, controller )
	self:setHandleMouse( true )
end

CoD.T10WeaponUpgradeTabWidget = InheritFrom( LUI.UIElement )
CoD.T10WeaponUpgradeTabWidget.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10WeaponUpgradeTabWidget )
	self.id = "T10WeaponUpgradeTabWidget"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 96 )
	self:setTopBottom( true, false, 0, 19 )
	self.anyChildUsesUpdateState = true
	
	self.focus = LUI.UIImage.new()
	self.focus:setLeftRight( true, true, 0, 0 )
	self.focus:setTopBottom( true, true, 0, 0 )
	self.focus:setImage( RegisterImage( "ximage_c3915c4fd60dd57" ) )
	self:addElement( self.focus )
	
	self.text = LUI.UIText.new()
	self.text:setLeftRight( true, true, -100, 100 )
	self.text:setTopBottom( true, true, -2.5, 2.5 )
	self.text:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.text:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.text:setScale( 0.5 )
	self.text:linkToElementModel( self, "tabName", true, function ( model )
		local tabName = Engine.GetModelValue( model )

		if tabName then
			self.text:setText( Engine.Localize( tabName ) )
		end
	end )
	self:addElement( self.text )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )

				self.focus:completeAnimation()
				self.focus:setAlpha( 0 )
				self.clipFinished( self.focus, {} )

				self.text:completeAnimation()
				self.text:setRGB( 1, 1, 1 )
				self.clipFinished( self.text, {} )
			end,
			Active = function ()
				self:setupElementClipCounter( 2 )

				self.focus:completeAnimation()
				self.focus:setAlpha( 1 )
				self.clipFinished( self.focus, {} )

				self.text:completeAnimation()
				self.text:setRGB( 0, 0, 0 )
				self.clipFinished( self.text, {} )
			end,
			Over = function ()
				self:setupElementClipCounter( 2 )

				self.focus:completeAnimation()
				self.focus:setAlpha( 1 )
				self.clipFinished( self.focus, {} )

				self.text:completeAnimation()
				self.text:setRGB( 0, 0, 0 )
				self.clipFinished( self.text, {} )
			end
		}
	}

	if self.m_eventHandlers.input_source_changed then
		local currentEv = self.m_eventHandlers.input_source_changed

		self:registerEventHandler( "input_source_changed", function ( self, event )
			event.menu = event.menu or menu

			self:updateState( event )

			return currentEv( self, event )
		end )
	else
		self:registerEventHandler( "input_source_changed", LUI.UIElement.updateState )
	end

	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "LastInput"
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.focus:close()
		element.text:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
