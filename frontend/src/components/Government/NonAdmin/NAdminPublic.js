import React from 'react'
import Button from "react-bootstrap/Button";
import { Link } from "react-router-dom";

export default function NAdminPublic() {
  return (
    <div>
      <Link to="/government/admin-public">
        <Button variant="warning">Admin Panel</Button>
      </Link>
      <br />
      NAdminPublic
    </div>
  )
}
