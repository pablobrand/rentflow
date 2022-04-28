import AppBar from "@mui/material/AppBar";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import IconButton from '@mui/material/IconButton';
import Typography from "@mui/material/Typography";
import styles from "./navbar.module.css";

const NavBar = () => {
  return (
    <Box >
      <AppBar className = {styles.navbar} position="static">
        <Toolbar>
          <IconButton
            size="large"
            edge="start"
            color="inherit"
            aria-label="open drawer"
            sx={{ mr: 2 }}
          >
          </IconButton>
          <Typography
            variant="h6"
            noWrap
            component="div"
            sx={{ flexGrow: 1, display: { xs: "none", sm: "block" } }}
          >
            Local Border - Home
          </Typography>

        </Toolbar>
      </AppBar>
    </Box>
  );
};

export default NavBar;
