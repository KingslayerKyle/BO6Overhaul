CoD.KingslayerPowerupsListItem = InheritFrom( LUI.UIElement )
CoD.KingslayerPowerupsListItem.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.KingslayerPowerupsListItem )
	self.id = "KingslayerPowerupsListItem"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 49 )
	self:setTopBottom( true, false, 0, 49 )

	self.image = LUI.UIImage.new()
	self.image:setLeftRight( true, false, 0, 49 )
	self.image:setTopBottom( true, false, 0, 49 )
	self.image:linkToElementModel( self, "image", true, function ( model )
		local image = Engine.GetModelValue( model )

		if image then
			self.image:setImage( RegisterImage( image ) )
		end
	end )
	self:addElement( self.image )

	self.timebackground1 = LUI.UIImage.new()
	self.timebackground1:setLeftRight( true, false, 30, 46 )
	self.timebackground1:setTopBottom( true, false, 30, 46 )
	self.timebackground1:setImage( RegisterImage( "uie_t7_hud_cp_bleeding_out_blur" ) )
	self.timebackground1:setRGB( 0.9, 0.80, 0.2 )
	self:addElement( self.timebackground1 )

	self.timebackground2 = LUI.UIImage.new()
	self.timebackground2:setLeftRight( true, false, 30, 46 )
	self.timebackground2:setTopBottom( true, false, 30, 46 )
	self.timebackground2:setImage( RegisterImage( "t7_icon_rank_zm_prestige_30" ) )
	self.timebackground2:setRGB( 0.2, 0.2, 0.2 )
	self.timebackground2:setScale( 0.95 )
	self:addElement( self.timebackground2 )

	self.time = LUI.UIText.new()
	self.time:setLeftRight( true, false, 30 - 100, 46 + 100 )
	self.time:setTopBottom( true, false, 30 - 3, 46 + 3 )
	self.time:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.time:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.time:setScale( 0.5 )
	self.time:linkToElementModel( self, "time", true, function ( model )
		local time = Engine.GetModelValue( model )
		
		if time then
			self.time:setText( Engine.Localize( time ) )
		end
	end )
	self:addElement( self.time )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				self.image:completeAnimation()
				self.image:setAlpha( 0 )
				self.clipFinished( self.image, {} )

				self.timebackground1:completeAnimation()
				self.timebackground1:setAlpha( 0 )
				self.clipFinished( self.timebackground1, {} )

				self.timebackground2:completeAnimation()
				self.timebackground2:setAlpha( 0 )
				self.clipFinished( self.timebackground2, {} )

				self.time:completeAnimation()
				self.time:setAlpha( 0 )
				self.clipFinished( self.time, {} )
			end
		},
		STATE_ON = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				self.image:completeAnimation()
				self.image:setAlpha( 1 )
				self.clipFinished( self.image, {} )

				self.timebackground1:completeAnimation()
				self.timebackground1:setAlpha( 1 )
				self.clipFinished( self.timebackground1, {} )

				self.timebackground2:completeAnimation()
				self.timebackground2:setAlpha( 1 )
				self.clipFinished( self.timebackground2, {} )

				self.time:completeAnimation()
				self.time:setAlpha( 1 )
				self.clipFinished( self.time, {} )
			end
		},
		STATE_FLASHING_OFF = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				self.image:completeAnimation()
				self.image:setAlpha( 0 )
				self.clipFinished( self.image, {} )

				self.timebackground1:completeAnimation()
				self.timebackground1:setAlpha( 0 )
				self.clipFinished( self.timebackground1, {} )

				self.timebackground2:completeAnimation()
				self.timebackground2:setAlpha( 0 )
				self.clipFinished( self.timebackground2, {} )

				self.time:completeAnimation()
				self.time:setAlpha( 0 )
				self.clipFinished( self.time, {} )
			end
		},
		STATE_FLASHING_ON = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				self.image:completeAnimation()
				self.image:setAlpha( 1 )
				self.clipFinished( self.image, {} )

				self.timebackground1:completeAnimation()
				self.timebackground1:setAlpha( 1 )
				self.clipFinished( self.timebackground1, {} )

				self.timebackground2:completeAnimation()
				self.timebackground2:setAlpha( 1 )
				self.clipFinished( self.timebackground2, {} )

				self.time:completeAnimation()
				self.time:setAlpha( 1 )
				self.clipFinished( self.time, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "STATE_ON",
			condition = function ( menu, element, event )
				return IsSelfModelValueEqualTo( element, controller, "state", 1 )
			end
		},
		{
			stateName = "STATE_FLASHING_OFF",
			condition = function ( menu, element, event )
				return IsSelfModelValueEqualTo( element, controller, "state", 2 )
			end
		},
		{
			stateName = "STATE_FLASHING_ON",
			condition = function ( menu, element, event )
				return IsSelfModelValueEqualTo( element, controller, "state", 3 )
			end
		}
	} )

	self:linkToElementModel( self, "state", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "state"
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.image:close()
		element.timebackground1:close()
		element.timebackground2:close()
		element.time:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
