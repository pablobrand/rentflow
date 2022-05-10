import Head from "next/head";
import Image from "next/image";
import NavBar from "../components/navbar/NavBar";
import styles from "../styles/Home.module.css";
import { useState } from "react";
import { ethers } from "ethers";

export default function LandloardDashboard() {
  
  return (
    <div>
      <Head>
        <title>RentFlow</title>
        <meta
          name="description"
          content="Chainlink Hackathon 2022 - RentFlow Project"
        />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <NavBar />
      <h1>Landloard Dashboard page</h1>
    </div>
  );
}
