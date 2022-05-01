import { useState, useEffect } from "react";
import Link from "next/link";
import { ethers } from "ethers";
import { styled } from "@mui/material/styles";
import Box from "@mui/material/Box";
import Paper from "@mui/material/Paper";
import Grid from "@mui/material/Grid";
import Typography from "@mui/material/Typography";
import styles from "./hometopsection.module.css";
import Container from "@mui/material/Container";
import Button from "@mui/material/Button";
import { abiLandloard } from "../abiVariables";
import { contractAddress } from "../globalInfo";

const Item = styled(Paper)(({ theme }) => ({
  padding: theme.spacing(2),
  textAlign: "center",
  color: theme.palette.text.secondary,
  margin: "auto",
  maxWidth: 500,
  background: "rgba(12, 27, 48, 0.2)",
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

  async function ExecuteAddTenant() {
    if (typeof window.ethereum != undefined) {
      //const contractAddress = "0x86b6244836273f5224905Af86cf66c5DCf537FbC";

      const contract = new ethers.Contract(
        contractAddress,
        abiLandloard,
        signer
      );
      try {
        let tenantTest = "0xAAB00377393a786e65CdE298b55fBF07Aaa0aD0A";
        await contract.addTenant(tenantTest);
        console.log("Tenant Added!!");
      } catch (error) {
        console.log(error);
        console.log(error.data.message)
      }
    } else {
      console.log("Please install MetaMask");
    }
  }
  async function ExecuteGetBalance() {
    if (typeof window.ethereum != undefined) {
      //const contractAddress = "0xd95b97fA24CfF91Bd2791cC144F7E172804697ed";

      const contract = new ethers.Contract(
        contractAddress,
        abiLandloard,
        signer
      );
      try {
        const landloardBalance = await contract.getBalance();
        const formatedBalance = ethers.utils.formatEther(landloardBalance)
        console.log("this is the landloard balance: " + formatedBalance);
      } catch (error) {
        console.log(error);
      }
    } else {
      console.log("Please install MetaMask");
    }
  }
  return (
    <Box className={styles.homeTopSectionBox}>
      <Item>
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
      <Container className={styles.buttonConnectWallet}>
        <Item>
          {hasMetamask ? (
            isConnected ? (
              "Connected! "
            ) : (
              <Button
                variant="contained"
                color="success"
                onClick={() => connectToMetamask()}
              >
                Connect to Metamask
              </Button>
            )
          ) : (
            "Please install metamask"
          )}
          {isConnected ? (
            <button onClick={() => ExecuteAddTenant()}>Add Tenant</button>
          ) : (
            ""
          )}
          {isConnected ? (
            <button onClick={() => ExecuteGetBalance()}>Get Balance</button>
          ) : (
            ""
          )}
        </Item>
      </Container>

      <Container className={styles.buttonsContainer} maxWidth="sm">
        <Item>
          <Button variant="contained" color="secondary">
            <Link href="/makeapayment">
              <a>Make a Payment</a>
            </Link>
          </Button>
          <Button variant="contained" color="secondary">
            <Link href="/landloarddashboard">
              <a>Landloard Dashboard</a>
            </Link>
          </Button>
        </Item>
      </Container>
    </Box>
  );
};

export default HomeTopSection;
