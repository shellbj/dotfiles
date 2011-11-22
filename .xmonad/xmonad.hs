import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Config.Xfce
import XMonad.Hooks.ManageHelpers

myManageHook = composeAll
    [
    className =? "Wrapper" --> doFloat,
    className =? "MPlayer" --> doFloat,
    className =? "Gimp" --> doFloat,
    className =? "Xfce4-appfinder" --> doCenterFloat,
    className =? "Xfrun4" --> doCenterFloat,
    className =? "Do" --> doCenterFloat,
    className =? "Xfce4-notes" --> doCenterFloat,
    className =? "Xfce4-panel"    --> doFloat,
    className =? "Xfce-mcs-manager" --> doFloat,
    className =? "Xfce-mixer"	      --> doFloat,
    resource  =? "desktop_window" --> doIgnore,
    resource  =? "Xfdesktop" --> doIgnore
    ]


main = xmonad xfceConfig
              {
                manageHook = manageDocks <+> myManageHook,
                modMask = mod4Mask
              }
