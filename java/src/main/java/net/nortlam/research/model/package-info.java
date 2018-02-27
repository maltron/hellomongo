/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
@XmlJavaTypeAdapters({
   @XmlJavaTypeAdapter(value=ObjectIdAdapter.class,type=ObjectId.class)
})
package net.nortlam.research.model;

import net.nortlam.research.convert.ObjectIdAdapter;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapters;
import org.bson.types.ObjectId;


