import React from 'react'
import Button from "react-bootstrap/Button";
import { Link } from "react-router-dom";

export default function NAdminIIITNR() {
  return (
    <div>
      <Link to="/education/engineering/admin-iiitnr">
      <Button variant="warning">Admin Panel</Button>
      </Link>
      <br />
      NAdminIIITNR
    </div>
  )
}
