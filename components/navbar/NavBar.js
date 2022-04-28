import AppBar from "@mui/material/AppBar"
import Box from "@mui/material/Box"
import Toolbar from "@mui/material/Toolbar"
import IconButton from "@mui/material/IconButton"
import Typography from "@mui/material/Typography"
import styles from "./navbar.module.css"

const NavBar = () => {
  return (
    <Box>
      <AppBar className={styles.navbar} position="static">
        <Toolbar>
          <Typography
            variant="h6"
            noWrap
            component="div"
            sx={{ flexGrow: 1, display: { xs: "none", sm: "block" } }}
          >
            RentFlow
          </Typography>
        </Toolbar>
      </AppBar>
    </Box>
  )
}

export default NavBar
