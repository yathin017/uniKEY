import React from "react";
import Nav from "react-bootstrap/Nav";
import Navbar from "react-bootstrap/Navbar";
import NavDropdown from "react-bootstrap/NavDropdown";
import Container from "react-bootstrap/Container";
import "bootstrap/dist/css/bootstrap.min.css";
import "../App.css";
import { Link } from "react-router-dom";

export default function navbar() {
  return (
    <div>
      <Navbar
        fixed="top"
        bg="dark"
        expand="lg"
        className="text-white"
        variant="dark"
      >
        <Container fluid>
          <Navbar.Brand>
            <img
              src="../../logo.svg"
              width="50"
              height="50"
              className="d-inline-block align-top"
              alt="logo"
            />
          </Navbar.Brand>
          <Navbar.Brand href="/">
            <h3>uniKEY</h3>
          </Navbar.Brand>
          <Navbar.Toggle aria-controls="navbarScroll" />
          <Navbar.Collapse id="navbarScroll">
            <Nav
              className="me-auto my-2 my-lg-0 mx-5"
              style={{ maxHeight: "100bh" }}
              navbarScroll
              id="nav-component"
            >
              <NavDropdown
                title="Government IDs"
                id="navbarScrollingDropdown"
                menuVariant="dark"
              >
                <NavDropdown.Item className="mx-1">
                  <Link id="link" to="/government/public">
                    Public Minutiae
                  </Link>
                </NavDropdown.Item>
                <NavDropdown.Item href="/government/aadhar" className="mx-1">
                  <Link id="link" to="/government/aadhar">
                    Aadhar Minutiae
                  </Link>
                </NavDropdown.Item>
                <NavDropdown.Item href="pan-minutiae" className="mx-1">
                  <Link id="link" to="/government/pan">
                    PAN Minutiae
                  </Link>
                </NavDropdown.Item>
                <NavDropdown.Item href="voter-minutiae" className="mx-1">
                  <Link id="link" to="/government/voter">
                    Voter Minutiae
                  </Link>
                </NavDropdown.Item>
                <NavDropdown
                  title="Driving License"
                  key="end"
                  drop="end"
                  id="navbarScrollingDropdown1"
                  menuVariant="dark"
                >
                  <NavDropdown.Item href="2-wheeler" className="mx-2">
                    <Link id="link" to="/government/driving-license/2-wheeler">
                      2 Wheeler
                    </Link>
                  </NavDropdown.Item>
                  <NavDropdown.Item href="4-wheeler" className="mx-2">
                    <Link id="link" to="/government/driving-license/4-wheeler">
                      4 Wheeler
                    </Link>
                  </NavDropdown.Item>
                </NavDropdown>
              </NavDropdown>

              <NavDropdown
                title="Education"
                id="navbarScrollingDropdown"
                menuVariant="dark"
              >
                <NavDropdown
                  title="Engineering"
                  key="end"
                  drop="end"
                  id="navbarScrollingDropdown1"
                  menuVariant="dark"
                >
                  <NavDropdown.Item href="iiitnr" className="mx-2">
                    <Link id="link" to="/education/engineering/iiitnr">
                      IIIT-NR
                    </Link>
                  </NavDropdown.Item>
                  <NavDropdown.Item
                    href="/education/engineering/clg-1"
                    className="mx-2"
                  >
                    College 1
                  </NavDropdown.Item>
                </NavDropdown>
                <NavDropdown
                  title="Medical"
                  key="end"
                  drop="end"
                  id="navbarScrollingDropdown1"
                  menuVariant="dark"
                >
                  <NavDropdown.Item
                    href="/education/medical/clg-1"
                    className="mx-2"
                  >
                    College 1
                  </NavDropdown.Item>
                  <NavDropdown.Item
                    href="/education/medical/clg-2"
                    className="mx-2"
                  >
                    College 2
                  </NavDropdown.Item>
                </NavDropdown>
                <NavDropdown
                  title="Commerce"
                  key="end"
                  drop="end"
                  id="navbarScrollingDropdown1"
                  menuVariant="dark"
                >
                  <NavDropdown.Item
                    href="/education/commerce/clg-1"
                    className="mx-2"
                  >
                    College 1
                  </NavDropdown.Item>
                  <NavDropdown.Item
                    href="/education/commerce/clg-2"
                    className="mx-2"
                  >
                    College 2
                  </NavDropdown.Item>
                </NavDropdown>
                <NavDropdown.Divider />
                <NavDropdown
                  title="Others"
                  key="end"
                  drop="end"
                  id="navbarScrollingDropdown1"
                  menuVariant="dark"
                >
                  <NavDropdown.Item className="mx-2">
                    <Link id="link" to="/education/others/coursera">
                      Coursera
                    </Link>
                  </NavDropdown.Item>
                  <NavDropdown.Item
                    href="/education/others/udemy"
                    className="mx-2"
                  >
                    Udemy
                  </NavDropdown.Item>
                </NavDropdown>
              </NavDropdown>

              <Nav.Link>
                <Link id="link" to="/healthcare">
                  Health Care
                </Link>
              </Nav.Link>

              <Nav.Link>
                <Link id="link" to="/finance">
                  Finance
                </Link>
              </Nav.Link>

              <Nav.Link>
                <Link id="link" to="/nft">
                  NFTs
                </Link>
              </Nav.Link>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
    </div>
  );
}
