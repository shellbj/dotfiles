import XMonad
import XMonad.Config.Xfce
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Reflect
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.Circle
import XMonad.Layout.PerWorkspace
import Data.Ratio ((%))
import XMonad.Layout.NoBorders
import XMonad.Layout.ShowWName

myWorkspaces = ["web", "mail", "emacs" ] ++ map show [4..9]

myManageHook :: ManageHook
myManageHook = composeAll . concat $
                [ [ className =?  i --> doIgnore | i <- ignores ]                
                , [ name =? n --> doIgnore | n <- namedIgnores ]
                , [ className =? cf --> doCenterFloat | cf <- centerFloats ]
                , [ className =?  f --> doFloat | f <- floats ]
                , [ className =?  d0 --> doShift (myWorkspaces !! 0) | d0 <- web ]
                , [ className =?  d1 --> doShift (myWorkspaces !! 1) | d1 <- mail ]
                , [ className =?  d2 --> doShift (myWorkspaces !! 2) | d2 <- emacs ]
                ]
                where
                  name = stringProperty "WM_NAME"
                  web = [ "Chromium-browser", "Google-chrome", "chromium-browser", "chromium-dev" ]
                  mail = [ "Pidgin", "Thunderbird" ]
                  emacs = [ "emacs", "Emacs" ]
                  namedIgnores = [ "Whisker Menu" ]
                  ignores = [ "Xfce4-notifyd"  -- notifications will steal focus otherwise
                              -- , "Xfdesktop"
                              -- , "desktop_window"
                            ]
                  centerFloats = [ "Xfce4-appfinder"
                                 , "Xfrun4"
                                   -- , "Do"
                                   -- , "Xfce4-notes"
                                 ]
                  floats = [ "MPlayer"
                             -- , "Wrapper"
                             -- , "Gimp"
                             -- , "Xfce4-panel"
                             -- , "Xfce4-mcs-manager"
                             -- , "Xfce4-mixer"
                           ]

myLayoutHook = avoidStruts . smartBorders . showWName
               $ onWorkspaces ["mail", (myWorkspaces !! 1)] (reflectHoriz $ withIM (1%7) (Title "Buddy List") layout)
               $ layout
               where
                 layout = ( tiled ||| (Mirror tiled) ||| noBorders Full ||| Grid ||| Circle )
                 tiled = Tall nmaster delta ratio
                 nmaster = 1
                 ratio = 1/2
                 delta = 3/100

main = xmonad $ xfceConfig {
  manageHook = myManageHook <+> manageHook xfceConfig
  , workspaces = myWorkspaces
  , terminal = "xfce4-terminal"
  , modMask = mod4Mask
  , layoutHook = myLayoutHook
  }
