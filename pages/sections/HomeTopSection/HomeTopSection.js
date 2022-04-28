import { styled } from "@mui/material/styles"
import Box from "@mui/material/Box"
import Paper from "@mui/material/Paper"
import Grid from "@mui/material/Grid"
import Typography from "@mui/material/Typography"
import styles from "./hometopsection.module.css"
import Container from "@mui/material/Container"

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === "dark" ? "#1A2027" : "#fff",
  ...theme.typography.fontWeightBold,
  padding: theme.spacing(1),
  textAlign: "center",
  color: theme.palette.text.secondary,
  margin: "auto",
  maxWidth: 500,
}))
const HomeTopSection = () => {
  return (
    <Box className={styles.homeTopSectionBox}>
      <Item className={styles.homeTopItem}>
        <Typography className={styles.homeTopText} variant="h4" component="h4">
          What is RentFlow?
        </Typography>
        <Typography className={styles.homeMainText} variant="body1">
          RentFlow is a Business to Business rental income investing tool that
          will collect all your rental income and lend it out to DeFi plataforms
          to earn money for you. Easily receive payments from your renters, and
          let our automated system do the reallocation and heavy lifting for
          you. Best of of, you have full control of your investments.
        </Typography>
      </Item>
    </Box>
  )
}

export default HomeTopSection
