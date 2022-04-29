import { useState, useEffect } from "react";
import { ethers } from "ethers";
import { styled } from "@mui/material/styles";
import Box from "@mui/material/Box";
import Paper from "@mui/material/Paper";
import Grid from "@mui/material/Grid";
import Typography from "@mui/material/Typography";
import styles from "./hometopsection.module.css";
import Container from "@mui/material/Container";
import Button from "@mui/material/Button";

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === "dark" ? "#1A2027" : "#fff",
  ...theme.typography.fontWeightBold,
  padding: theme.spacing(1),
  textAlign: "center",
  color: theme.palette.text.secondary,
  margin: "auto",
  maxWidth: 500,
}));
const HomeTopSection = () => {
  const [isConnected, setIsConnected] = useState(false);
  const [hasMetamask, setHasMetamask] = useState(false);
  const [signer, setSigner] = useState(undefined);

  useEffect(() => {
    if (typeof window.ethereum !== "undefined") {
      setHasMetamask(true);
    }
  });

  async function connectToMetamask() {
    if (typeof window.ethereum !== "undefined") {
      try {
        await ethereum.request({ method: "eth_requestAccounts" });
        setIsConnected(true);
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        setSigner(provider.getSigner());
      } catch (e) {
        console.log(e);
      }
    } else {
      setIsConnected(false);
    }
  }

  //async function execute() {}
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
      <Item>
      {hasMetamask ? (
        isConnected ? (
          "Connected! "
        ) : (
        <Button onClick={() => connectToMetamask()}>Connect to Metamask</Button>
      )) : (
        "Please install metamask"
      )}
      </Item>
    </Box>
  );
};

export default HomeTopSection;
