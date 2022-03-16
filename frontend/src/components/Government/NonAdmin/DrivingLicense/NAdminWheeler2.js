import React from 'react'
import Button from "react-bootstrap/Button";
import { Link } from "react-router-dom";

export default function NAdminWheeler2() {
  return (
    <div>
      <Link to="/government/driving-license/admin-2-wheeler">
        <Button variant="warning">Admin Panel</Button>
      </Link>
      <br />
      NAdminWheeler2
    </div>
  )
}
